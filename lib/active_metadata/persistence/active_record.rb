module ActiveMetadata::Persistence::ActiveRecord

  require "model/active_record/note"
  require "active_metadata/persistence/active_record/note"
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
              
  module InstanceMethods
    
    include ActiveMetadata::Persistence::ActiveRecord::Note

  end                         

end