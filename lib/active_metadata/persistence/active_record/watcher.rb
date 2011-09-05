module ActiveMetadata::Persistence::ActiveRecord::Watcher

  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end

  module InstanceMethods
    def create_watcher_for(field, owner)
      raise RuntimeError, "The object id MUST be valued" unless self.id

      label_path(field).watchers.create!(:owner_id => owner.id, :created_at => Time.now.utc, :updated_at => Time.now.utc)

      owner.create_inbox unless owner.inbox # ensure that an inbox is present
    end                      

    def watchers_for(field)
      Watcher.all(:conditions => {:label => field, :document_id => metadata_id})   
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
      watchers_for(field).each { |watch| watch.notify_changes(field, old_value, new_value, self.class, self.id) }
    end
  end

end
