module ActiveMetadata

  CONFIG = File.exists?('config/active_metadata.yml') ? YAML.load_file('config/active_metadata.yml')[Rails.env] : {}
  CONFIG['cache_expires_in'] ||= 60

  ## Define ModelMethods
  module Base

    require 'paperclip'
    require "active_metadata/persistence/persistence"
    require "active_metadata/helpers"

    def self.included(klass)
      klass.class_eval do
        extend Config
      end
    end

    module Config

      def acts_as_metadata *args
        before_update :manage_concurrency
        after_save :save_history
        attr_accessor :conflicts
        attr_accessor :active_metadata_timestamp

        class_variable_set("@@metadata_id_from", args.empty? ? nil : args[0][:metadata_id_from])

        include ActiveMetadata::Base::InstanceMethods
        include ActiveMetadata::Persistence

      end

    end

    module InstanceMethods

      include ActiveMetadata::Helpers

      def attributes=(attributes)
        attributes.delete(:active_metadata_timestamp) unless attributes[:active_metadata_timestamp].nil?
        super
      end

      def self.included(klass)
        [:notes, :attachments, :history].each do |item|
          klass.send(:define_method, "#{item.to_s}_cache_key".to_sym) do |field|
            "#{Rails.env}/active_metadata/#{item.to_s}/#{self.class}/#{metadata_id}/#{field}/"
          end
        end
      end

      def metadata_id
        metadata_root.id
      end

      def active_metadata_timestamp
        metadata_root.active_metadata_timestamp || nil
      end

      def current_user_id
        if User.respond_to?(:current) && !User.current.nil?
          User.current.id
        else
          nil
        end
      end

      def metadata_root
        metadata_id_from = self.class.class_variable_get("@@metadata_id_from")
        return self if metadata_id_from.nil?
        receiver = self
        metadata_id_from.each do |item|
          receiver = receiver.send item
        end
        receiver
      end

      # Resolve concurrency using the provided timestamps and the active_metadata histories.
      # Conflicts are stored into @conflicts instance variable
      #
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
      #  the data
      #
      # * @conflicts[:fatals] contains any conflict that "do not apply cleanly" or where the passed value does not match the last history value and was modified
      #   by the user that is submittig the data
      #
      def manage_concurrency
        return if active_metadata_timestamp.nil? #if no timestamp no way to check concurrency so just skip

        self.conflicts = { :warnings => [], :fatals => [] }

        # scan params
        self.attributes.each do |key, val|
          # ensure the query order
          histories = history_for key.to_sym, "created_at DESC"
          latest_history = histories.first
          timestamp = self.active_metadata_timestamp

          # if form timestamp is subsequent the history last change go on
          # if history does not exists yet go on
          next if latest_history.nil? || timestamp > latest_history.created_at

          #if the timestamp is previous of the last history change
          if timestamp < latest_history.created_at

            begin
              self[key.to_sym] = self.changes[key][0]
            rescue
            end  # there is a conflict so ensure the actual value if any change exists

            # We have a conflict.
            # Check if the actual submission has been modified
            histories.each do |h|
              # Looking for the value that was loaded by the user. First history with a ts that is younger than the form ts
              next if timestamp > h.created_at

              # History stores values as strings so any boolean is stored as "0" or "1"
              # We need to translate the params passed for a safer comparison.
              if self.column_for_attribute(key).type == :boolean
                b_val = to_bool(h.value)
              end

              if [h.value, b_val].include? val
                self.conflicts[:warnings] << {key.to_sym => [val, h]}
              else
                self.conflicts[:fatals] << {key.to_sym => [val, h]}
              end
            end

          end

        end

      end

    end # InstanceMethods

  end

end

::ActiveRecord::Base.send :include, ActiveMetadata::Base

