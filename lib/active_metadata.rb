require "active_metadata/version"

require "mongo"

module ActiveMetadata

  def self.included(klazz)
    klazz.after_initialize :initialize_metadata
  end
  
  #TODO add a configure routine
  MONGO = Mongo::Connection.new.db "metadata"

  def initialize_metadata
    attributes.each do |key,value|

      self.class.send(:define_method,"create_note_for_#{key}") do |note|
        coll = MONGO["notes"]
        raise RuntimeError, "The object id MUST be valued" unless self.id
        coll.insert :note => note, :id => self.id

      end

      self.class.send(:define_method,"update_note_for_#{key}") do |id,note|
        coll = MONGO["notes"]
        coll.update({:_id => id},{"$set" => {:note => note}})
      end

      self.class.send(:define_method,"notes_for_#{key}") do
        coll = MONGO["notes"]
        cursor = coll.find(:id => self.id).to_a
      end

      self.class.send(:define_method,"notes_for_#{key}=") do

      end

    end
  end
end

class ActiveRecord::Base      
  def self.act_as_metadata
    include ActiveMetadata
  end
end
