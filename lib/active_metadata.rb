require "active_metadata/version"
require "mongo"

module ActiveMetadata

  #TODO add a configure routine
  MONGO = Mongo::Connection.new.db "metadata"

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def act_as_metadata
      p self.class
    end
  end

end

module ActiveRecord
  class Base
    include ActiveMetadata
  end
end

