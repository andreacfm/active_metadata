require "active_metadata/version"

require "mongo"

module ActiveMetadata

  #TODO add a configure routine
  MONGO = Mongo::Connection.new.db "metadata"

  def create_note_for field, note
    coll = MONGO["notes"]
    raise RuntimeError, "The object id MUST be valued" unless self.id
    coll.insert :note => note, :id => self.id, :field => field
  end

  def update_note id, note
    coll = MONGO["notes"]
    coll.update({:_id => id}, {"$set" => {:note => note}})
  end

  def notes_for field
    coll = MONGO["notes"]
    cursor = coll.find({:id => self.id, :field => field}).to_a
  end

  def notes_for= field, notes

  end

end

class ActiveRecord::Base
  def self.act_as_metadata
    include ActiveMetadata
  end
end
