module ActiveMetadata::Persistence::ActiveRecord::Watcher

  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end

  module InstanceMethods
    def create_watcher_for(field, owner)
      raise RuntimeError, "The object id MUST be valued" unless self.id
      Watcher.create! :document_id => metadata_id, :label => field, :owner_id => owner.id 
    end                      

    def watchers_for(field)
      Watcher.all(:conditions => {:label => field, :document_id => metadata_id})   
    end

    def delete_watcher_for(field, owner)
      Watcher.where(:document_id => metadata_id, :label => field, :owner_id => owner.id).each do |watcher|
        watcher.destroy
      end   
    end    
    
    def is_watched_by(field,owner)
      Watcher.where(:document_id => metadata_id, :label => field, :owner_id => owner.id).empty? ? false : true 
    end                    

    # This is a callback method of the after_save of the ActiveRecord
    # object. 
    # TODO: It should definetly be decoupled in time from the save of
    # the alerting system
    def on_save_watcher_callback                          
      self.changes.each do |field, values|
        send_notification(field, values.first, values.last)
      end
    end

    def send_notification(field, old_value, new_value)   
      watchers_for(field).each { |watch| notify_changes(field, old_value, new_value, self.class.to_s, self.id, watch.owner_id) }
    end
          
    def notifier
      @notifier
    end
    
    private
    def notify_changes(matched_label, old_value, new_value, model_class, model_id, owner_id)    
      raise "A watcher notifier class must be implemented" unless WatcherNotifier

      @notifier = WatcherNotifier.new
      @notifier.notify(matched_label.to_s, old_value, new_value, model_class, model_id,owner_id)                                                                               
    end
    
  end

end
