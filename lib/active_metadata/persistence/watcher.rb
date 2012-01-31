module ActiveMetadata::Persistence::Watcher

  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end

  module InstanceMethods
    def create_watcher_for(field, owner)
      raise RuntimeError, "The object id MUST be valued" unless self.id
      ActiveMetadata::Watcher.create! :document_class => metadata_class, :document_id => metadata_id, :label => field, :owner_id => owner.id
    end                      

    def watchers_for(field)
      ActiveMetadata::Watcher.all(:conditions => {:document_class => metadata_class, :label => field, :document_id => metadata_id})
    end

    def delete_watcher_for(field, owner)
      ActiveMetadata::Watcher.where(:document_id => metadata_id, :label => field, :owner_id => owner.id).each do |watcher|
        watcher.destroy
      end   
    end    
    
    def is_watched_by(field,owner)
      ActiveMetadata::Watcher.where(:document_class => metadata_class, :document_id => metadata_id, :label => field, :owner_id => owner.id).empty? ? false : true
    end                    

    def send_notification(field, old_value, new_value, type=:default_message, created_by=nil)   
      watchers_for(field).each { |watch| notify_changes(field, old_value, new_value, self.class.to_s, self.id, watch.owner_id, type, created_by) }
    end
          
    def notifier
      @notifier
    end
    
    private
    def notify_changes(matched_label, old_value, new_value, model_class, model_id, owner_id, type, created_by)    
      raise "A watcher notifier class must be implemented" unless WatcherNotifier

      @notifier = WatcherNotifier.new
      @notifier.notify(matched_label.to_s, old_value, new_value, model_class, model_id,owner_id,type, created_by)                                                                               
    end
    
  end

end
