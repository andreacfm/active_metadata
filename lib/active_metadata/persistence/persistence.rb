module ActiveMetadata::Persistence

  require "active_metadata/persistence/note"
  require "active_metadata/persistence/history"
  require "active_metadata/persistence/watcher"
  require "active_metadata/persistence/attachment"

  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end

  module InstanceMethods
    include ActiveMetadata::Persistence::Note
    include ActiveMetadata::Persistence::History
    include ActiveMetadata::Persistence::Watcher
    include ActiveMetadata::Persistence::Attachment
  end

end