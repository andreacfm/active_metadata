require "active_metadata/version"

require "mongo"

module ActiveMetadata

  def self.included(klazz)
    klazz.after_initialize :initialize_metadata
  end
  
  #TODO add a configure routine
  MONGO = Mongo::Connection.new.db "metadata"

  def initialize_metadata
    puts "#{attributes}"
  end
  
end

class ActiveRecord::Base      
  def self.act_as_metadata
    include ActiveMetadata
  end
end
