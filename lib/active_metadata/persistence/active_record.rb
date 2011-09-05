module ActiveMetadata::Persistence::ActiveRecord

  require "model/active_record/note"
  require "model/active_record/history"
  require "model/active_record/watcher"
  
  require "active_metadata/persistence/active_record/note"
  require "active_metadata/persistence/active_record/history"
  require "active_metadata/persistence/active_record/watcher"
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
              
  module InstanceMethods
    
    include ActiveMetadata::Persistence::ActiveRecord::Note
    include ActiveMetadata::Persistence::ActiveRecord::History
    include ActiveMetadata::Persistence::ActiveRecord::Watcher

  end                         

end