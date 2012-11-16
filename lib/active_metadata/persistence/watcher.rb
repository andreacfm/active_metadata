module ActiveMetadata::Persistence::Watcher

  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end

  module InstanceMethods
    def create_watcher_for(field, owner)
      raise RuntimeError, "The object id MUST be valued" unless self.id
      ActiveMetadata::Watcher.create! :model_class => metadata_class, :model_id => metadata_id, :label => field, :owner_id => owner.id
    end                      

    # return all the watches related to a passed field.
    # query always match for the current model
    # matches are returned grouped by owner and contains records that define or not a particular model instance watching
    def watchers_for(field)
      ActiveMetadata::Watcher.select("distinct(owner_id)").where(
          "model_class = :model_class AND label = :label AND (model_id = :model_id OR model_id IS NULL)",
          { :model_class => metadata_class, :label => field, :model_id => metadata_id }
          )
    end

    def delete_watcher_for(field, owner)
      ActiveMetadata::Watcher.where(:model_id => metadata_id, :label => field, :owner_id => owner.id).each do |watcher|
        watcher.destroy
      end   
    end    
    
    def is_watched_by(field,owner)
      ActiveMetadata::Watcher.where(:model_class => metadata_class, :model_id => metadata_id, :label => field, :owner_id => owner.id).empty? ? false : true
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
