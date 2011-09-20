module ActiveMetadata

  CONFIG = File.exists?('config/active_metadata.yml') ? YAML.load_file('config/active_metadata.yml')[Rails.env] : {}
 
  ## Define ModelMethods
  module Base
    
    require 'mongoid' if ActiveMetadata::CONFIG['persists_with'] == 'mongoid'
    require 'mongoid_paperclip' if ActiveMetadata::CONFIG['persists_with'] == 'mongoid'
    require 'paperclip' if ActiveMetadata::CONFIG['persists_with'] == 'active_record'
    require "active_metadata/persistence/persistence"

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
        include ActiveMetadata::Persistence   
             
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
      
      def current_user_id
        User.current.id if User.respond_to?(:current)
      end  
                
    end # InstanceMethods
  end

end

::ActiveRecord::Base.send :include, ActiveMetadata::Base

