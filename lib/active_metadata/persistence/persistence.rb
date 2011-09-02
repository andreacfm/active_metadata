module ActiveMetadata::Persistence

  require "active_metadata/persistence/mongoid"
  require "active_metadata/persistence/active_record"  
  
  def self.included(receiver)
    persister = Mongoid.nil? ? ActiveMetadata::Persistence::ActiveRecord : ActiveMetadata::Persistence::Mongoid    
    receiver.send :include, persister
  end

end