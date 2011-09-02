module ActiveMetadata::Persistence
  
  PERSISTS_WITH = ActiveMetadata::CONFIG['persists_with']
  
  require "active_metadata/persistence/mongoid" if PERSISTS_WITH == 'mongoid'
  require "active_metadata/persistence/active_record" if PERSISTS_WITH == 'active_record' 
  
  def self.included(receiver)
    persister = PERSISTS_WITH == 'active_record' ? ActiveMetadata::Persistence::ActiveRecord : ActiveMetadata::Persistence::Mongoid 
    receiver.send :include, persister
  end

end