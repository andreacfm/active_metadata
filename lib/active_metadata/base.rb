module ActiveMetadata

  CONFIG = File.exists?('config/active_metadata.yml') ? YAML.load_file('config/active_metadata.yml')[Rails.env] : {}
  CONFIG['cache_expires_in'] ||= 60
  CONFIG['cache_prefix'] ||= ""

  def self.skip_history?
    false
  end

  ## Define ModelMethods
  module Base

    require 'active_metadata/helpers'
    require 'active_metadata/stream'
    require 'paperclip'
    require 'active_metadata/persistence/persistence'
    require 'active_metadata/value_formatter'
    require 'active_metadata/exceptions'

    def self.included(klass)
      klass.class_eval do
        extend Config
      end
    end

    module Config

      def acts_as_metadata *args
        options = args.extract_options!
        options[:ancestors] ||= []
        options[:persists_ancestor] ||= false

        before_update :manage_concurrency
        after_save :save_history
        attr_accessor :conflicts, :active_metadata_timestamp, :skip_history_notification

        alias_method :skip_history_notification?, :skip_history_notification

        instance_variable_set("@active_metadata_options", options)

        include ActiveMetadata::Base::InstanceMethods
        include ActiveMetadata::Persistence
        include ActiveMetadata::Stream

      end

    end

    module InstanceMethods

      include ActiveMetadata::Helpers

      def self.included(klass)

        [:notes, :attachments, :history].each do |item|
          klass.send(:define_method, "#{item.to_s}_cache_key".to_sym) do |field|
            "#{CONFIG['cache_prefix'] + Rails.env}:active_metadata/#{item.to_s}/#{self.class}/#{metadata_id}/#{field}/"
          end
        end

        [:fatals, :warnings].each do |conf|
          klass.send(:define_method, "has_#{conf.to_s}_conflicts?".to_sym) do
            return false if self.conflicts.nil? || self.conflicts[conf.to_sym].nil? || self.conflicts[conf.to_sym].empty?
            true
          end
        end

      end

      # if force is set to true go directly to the private find method
      # options integrity will not be checked and ancestor will be looked also if option persists_ancestor is false
      # usefull to get the ancestor instance also if is not persisted
      def metadata_id force=false
        force ? find_metadata_ancestor_instance.id : metadata_root.id
      end

      # same as #metadata_id
      def metadata_class force=false
        force ? find_metadata_ancestor_instance.class.to_s : metadata_root.class.to_s
      end

      # Normalize the active_metadata_timestamp into a float to be comparable with the history
      def am_timestamp
        ts = metadata_root.active_metadata_timestamp
        return nil if ts.nil?
        ts = ts.to_f
      end

      def current_user_id
        if User.respond_to?(:current) && !User.current.nil?
          User.current.id
        else
          nil
        end
      end

      def metadata_root
        options = self.class.instance_variable_get("@active_metadata_options")
        return self unless (options[:persists_ancestor] && options[:ancestors].size > 0 )
        find_metadata_ancestor_instance
      end

      # Resolve concurrency using the provided timestamps and the active_metadata histories.
      # Conflicts are stored into @conflicts instance variable
      # Timestamp used for versioning can be passed both as :
      # ====
      # * @object.active_metadata_timestamp = ....
      # * @object.update_attributes :active_metadata_timestamp => ...
      #
      # Check is skipped if no timestamp exists. A check is made also for parents defined via acts_as_metadata method
      #
      # Conflicts
      # ====
      # * @conflicts[:warnings] contains any conflict that "apply cleanly" or where the submit value has not been modified by the user that is saving
      #  the data.
      #
      # * @conflicts[:fatals] contains any conflict that "do not apply cleanly" or where the passed value does not match the last history value and was modified
      #   by the user that is submittig the data
      #
      def manage_concurrency
        timestamp = self.am_timestamp
        return if timestamp.nil? #if no timestamp no way to check concurrency so just skip

        self.conflicts = { :warnings => [], :fatals => [] }

        # scan params
        self.attributes.each do |key, val|
          # ensure the query order
          histories = history_for key.to_sym, "created_at DESC"

          # if history does not exists yet cannot be a conflict  OR
          # if value has no change respect to the latest db saved we have no conflict
          next if histories.count == 0 || self.changes[key].nil?

          latest_history = histories.first

          #if the timestamp is previous of the last history change
          if timestamp < latest_history.created_at.to_f

            # We have a conflict.
            # Check if the actual submission has been modified
            histories.each_with_index do |h,i|
              # Looking for the value that was loaded by the user. First history with a ts that is younger than the form ts
              next if h.created_at.to_f > timestamp

              # History stores values as strings so any boolean is stored as "0" or "1"
              # We need to translate the params passed for a safer comparison.
              if self.column_for_attribute(key).type == :boolean
                b_val = to_bool(h.value)
              end

              # conflict ensure the actual value is not modified
              self[key.to_sym] = self.changes[key][0]

              if [h.value, b_val].include? val
                self.conflicts[:warnings] << {key.to_sym => latest_history}
              else
                self.conflicts[:fatals] << {key.to_sym => latest_history}
              end

              break #done for this field
            end

          end

        end

      end

      private

      def find_metadata_ancestor_instance
        receiver = self
        self.class.instance_variable_get("@active_metadata_options")[:ancestors].each do |item|
          res = receiver.send item
          receiver = res.is_a?(Array) ? res.first : res
        end
        raise(AncestorNotYetPersistedException.new,"[active_metdata] - Ancestor model is not yet persisted") unless receiver
        receiver
      end

    end # InstanceMethods

  end

end

::ActiveRecord::Base.send :include, ActiveMetadata::Base

