require "active_metadata/version"

require "mongo"

module ActiveMetadata

  def self.included(klazz)
    klazz.after_initialize :initialize_metadata
  end
  
  #TODO add a configure routine
  MONGO = Mongo::Connection.new.db "metadata"

  def initialize_metadata
    p attributes
    attributes.each do |key,value|

      self.class.send(:define_method,"create_nota_for_#{key}") do |note|
        coll = MONGO["note"]
        coll.insert :note => note
      end

      self.class.send(:define_method,"update_nota_for_#{key}") do

      end

      self.class.send(:define_method,"note_for_#{key}") do
        ["0"]
      end

      self.class.send(:define_method,"note_for_#{key}=") do

      end

    end
  end
end

class ActiveRecord::Base      
  def self.act_as_metadata
    include ActiveMetadata
  end
end
