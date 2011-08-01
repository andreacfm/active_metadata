module ActiveMetadata::Watcher

  module InstanceMethods
    def create_watcher_for(field, owner)
      raise RuntimeError, "The object id MUST be valued" unless self.id
      
      label_path(field.to_s).watchers.create!(:owner => owner, :created_at => Time.now.utc, :updated_at => Time.now.utc)
    end                      

    private    
    def label_path(field_name)
      ActiveMeta.find_or_create_by(:document_id => metadata_id).labels.find_or_create_by(:name => field_name)
    end
  end
end