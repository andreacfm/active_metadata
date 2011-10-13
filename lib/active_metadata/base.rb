module ActiveMetadata

  CONFIG = File.exists?('config/active_metadata.yml') ? YAML.load_file('config/active_metadata.yml')[Rails.env] : {}
  CONFIG['cache_expires_in'] ||= 60
  
  ## Define ModelMethods
  module Base
    
    require 'paperclip'
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
      
      def self.included(klass)
        [:notes,:attachments,:history].each do |item|
          klass.send(:define_method,"#{item.to_s}_cache_key".to_sym) do |field|
            p "active_metadata/#{item.to_s}/#{self.class}/#{metadata_id}/#{field}/"            
          end  
        end          
      end

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
        if User.respond_to?(:current) && !User.current.nil?
            User.current.id
        else
          nil
        end      
      end        
                
    end # InstanceMethods
  end

end

::ActiveRecord::Base.send :include, ActiveMetadata::Base

