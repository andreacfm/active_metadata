module ActiveMetadata::Persistence::ActiveRecord

  require "model/active_record/note"
  require "model/active_record/history"
  require "model/active_record/watcher"
  require "model/active_record/attachment"
  require "model/active_record/stream"

  require "active_metadata/persistence/active_record/note"
  require "active_metadata/persistence/active_record/history"
  require "active_metadata/persistence/active_record/watcher"
  require "active_metadata/persistence/active_record/attachment"

  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
              
  module InstanceMethods
    
    include ActiveMetadata::Persistence::ActiveRecord::Note
    include ActiveMetadata::Persistence::ActiveRecord::History
    include ActiveMetadata::Persistence::ActiveRecord::Watcher
    include ActiveMetadata::Persistence::ActiveRecord::Attachment

  end                         

end