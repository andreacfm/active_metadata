require "active_metadata/version"
require "mongo"

module ActiveMetadata

  #TODO add a configure routine
  MONGO = Mongo::Connection.new.db "metadata"

  def act_as_metadata


  end

end
