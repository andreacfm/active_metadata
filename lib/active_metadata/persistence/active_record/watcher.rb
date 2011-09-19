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

    def send_notification(field, old_value, new_value, type=:default_message)   
      watchers_for(field).each { |watch| notify_changes(field, old_value, new_value, self.class.to_s, self.id, watch.owner_id,type) }
    end
          
    def notifier
      @notifier
    end
    
    private
    def notify_changes(matched_label, old_value, new_value, model_class, model_id, owner_id,type)    
      raise "A watcher notifier class must be implemented" unless WatcherNotifier

      @notifier = WatcherNotifier.new
      @notifier.notify(matched_label.to_s, old_value, new_value, model_class, model_id,owner_id,type)                                                                               
    end
    
  end

end
