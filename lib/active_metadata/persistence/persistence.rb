module ActiveMetadata::Persistence
  
  require "active_metadata/persistence/active_record" 
  
  def self.included(receiver)
    receiver.send :include, ActiveMetadata::Persistence::ActiveRecord
  end

end