require "active_metadata/version"

require "mongo"

module ActiveMetadata

  #TODO add a configure routine
  MONGO = Mongo::Connection.new.db "metadata"

  def create_note_for(field, note, created_by=nil)
    coll = MONGO["notes"]
    
    raise RuntimeError, "The object id MUST be valued" unless self.id
    
    coll.insert :note => note, :id => self.id, :field => field , :created_at => Time.now.utc, :created_by => created_by, :updated_at => Time.now.utc
  end

  def update_note id, note, updated_by=nil
    coll = MONGO["notes"]
    coll.update({:_id => id}, {"$set" => {:note => note, :updated_at => Time.now.utc, :updated_by => updated_by}})
  end

  def notes_for field
    coll = MONGO["notes"]
    cursor = coll.find({:id => self.id, :field => field}).to_a
  end

  def create_notes_for field, notes
    notes.each do |note|
      create_note_for field,note
    end
  end

end

class ActiveRecord::Base
  def self.act_as_metadata
    include ActiveMetadata
  end
end
