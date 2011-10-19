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
        after_save :save_history
        class_variable_set("@@active_metadata_model", args.empty? ? nil : args[0][:active_metadata_model])

        include ActiveMetadata::Base::InstanceMethods
        include ActiveMetadata::Persistence

      end

    end

    module InstanceMethods

      include ActiveMetadata::Helpers

      def self.included(klass)
        [:notes,:attachments,:history].each do |item|
          klass.send(:define_method,"#{item.to_s}_cache_key".to_sym) do |field|
            "#{Rails.env}/active_metadata/#{item.to_s}/#{self.class}/#{metadata_model[:id]}/#{field}/"
          end  
        end          
      end

      def metadata_model
        metadata_model = self.class.class_variable_get("@@active_metadata_model")
        return {:id => self.id, :class => self.class.to_s} if metadata_model.nil?
        receiver = self
        metadata_model.each do |item|
          receiver = receiver.send item
        end
        {:id => receiver.id, :class => receiver.class.to_s}
      end

      def current_user_id
        if User.respond_to?(:current) && !User.current.nil?
          User.current.id
        else
          nil
        end
      end

      # Resolve concurrency using the passed timestamps and the active_metadata histories
      # To be called from controller before updating the model. Params that contains a conflict are removed from the params list.
      # Returns 2 values containing the the deleted params with the related history:
      # [{:key => [passed_value,history]}]
      #
      # first result is the WARNINGS array: conflict appears on a field not touched by the user that submit the value
      # first result is the FATALS Array : if the conflict appears on a field modified by the user that submit the value
      # an empty array is returned by default
      def manage_concurrency(params, timestamp)
        warnings = []
        fatals = []

        # scan params
        params.each do |key, val|
          # ensure the query order
          histories = history_for key.to_sym, "created_at DESC"
          latest_history = histories.first

          # if form timestamp is subsequent the history last change go on
          # if history does not exists yet go on
          next if latest_history.nil? || timestamp > latest_history.created_at

          #if the timestamp is previous of the last history change
          if timestamp < latest_history.created_at
            #remove the key from the update process
            params.delete key

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
                warnings << {key => [val, h]}
              else
                fatals << {key => [val, h]}
              end
            end

          end

        end

        return warnings, fatals
      end

    end # InstanceMethods

  end

end

::ActiveRecord::Base.send :include, ActiveMetadata::Base

