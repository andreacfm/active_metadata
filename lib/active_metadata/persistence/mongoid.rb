module ActiveMetadata::Persistence::Mongoid
 
    require "active_metadata/persistence/mongoid/attachment"
    require "active_metadata/persistence/mongoid/note"
    require "active_metadata/persistence/mongoid/history"
    require "active_metadata/persistence/mongoid/watcher"
    
    def self.included(receiver)
      receiver.send :include, InstanceMethods
    end
                
    module InstanceMethods
      
      include ActiveMetadata::Persistence::Mongoid::Note
      include ActiveMetadata::Persistence::Mongoid::History
      include ActiveMetadata::Persistence::Mongoid::Attachment
      include ActiveMetadata::Persistence::Mongoid::Watcher

      def label_path(field_name)
        ActiveMeta.find_or_create_by(:document_id => metadata_id).labels.find_or_create_by(:name => field_name.to_s)
      end              

    end                         
end