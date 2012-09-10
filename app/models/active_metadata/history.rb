module ActiveMetadata
  class History < ActiveRecord::Base
    self.table_name = "active_metadata_histories"
    include ActiveMetadata::ValueFormatter
  end
end
