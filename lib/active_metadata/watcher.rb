module ActiveMetadata::Watcher

  module InstanceMethods
    def create_watcher_for(field, owner)
      raise RuntimeError, "The object id MUST be valued" unless self.id
      
      label_path(field).watchers.create!(:owner_id => owner.id, :created_at => Time.now.utc, :updated_at => Time.now.utc)
    end                      

    def watchers_for(field)
      label_path(field).watchers.asc(:updated_at).to_a
    end
                        
    # This is a callback method of the after_save of the ActiveRecord
    # object. 
    # TODO: It should definetly be decoupled in time from the save of
    # the alerting system
    def watcher_callback
      self.changes.each do |label, values|
        watchers_for(label).each { |watch| watch.notify_changes(label,values) }
      end
    end
        
    private       
    def label_path(field_name)
      ActiveMeta.find_or_create_by(:document_id => metadata_id).labels.find_or_create_by(:name => field_name.to_s)
    end
  end
end