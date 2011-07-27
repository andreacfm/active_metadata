module ActiveMetadata

  if File.exists? 'config/active_metadata.yml' #this allows install task to run
    CONFIG = YAML.load_file('config/active_metadata.yml')[Rails.env]
  end


  ## Define ModelMethods
  module Base

    require "active_metadata/attachment"
    require "active_metadata/note"
    require "active_metadata/history"
    require "model/active_meta"
    require "model/label"
    require "model/note"
    require "model/history"
    require "model/attachment"

    def self.included(klass)
      klass.class_eval do
        extend Config
      end
    end

    module Config

      def acts_as_metadata *args
        after_save :save_history
        class_variable_set("@@metadata_id_from", args.empty? ? nil : args[0][:metadata_id_from])
        include ActiveMetadata::Base::InstanceMethods
        include ActiveMetadata::Attachment::InstanceMethods
        include ActiveMetadata::Note::InstanceMethods
        include ActiveMetadata::History::InstanceMethods
      end

    end

    module InstanceMethods

      def metadata_id
        metadata_id_from = self.class.class_variable_get("@@metadata_id_from")
        return self.id if metadata_id_from.nil?
        receiver = self
        metadata_id_from.each do |item|
          receiver = receiver.send item
        end
        receiver.id
      end

    end # InstanceMethods
  end

end

::ActiveRecord::Base.send :include, ActiveMetadata::Base

