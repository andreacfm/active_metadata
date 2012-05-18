module ActiveMetadata
  class Watcher < ActiveRecord::Base
    self.table_name = "active_metadata_watchers"
    attr_reader :notifier

  end
end
