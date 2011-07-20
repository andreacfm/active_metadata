require "active_metadata/version"
require "mongo"
require "active_metadata/railtie" if defined?(Rails)


module ActiveMetadata

  env = defined?(Rails) ? Rails.env : ENV['DATABASE_ENV']
  unless env.nil?
    CONFIG = YAML.load_file('config/mongo.yml')[env]
    CONNECTION = Mongo::Connection.new(CONFIG['host'],CONFIG['port']).db CONFIG['database']
  end

  def self.notes
    CONNECTION['notes']
  end

  def create_note_for(field, note, created_by=nil)    
    raise RuntimeError, "The object id MUST be valued" unless self.id

    ActiveMetadata.notes.insert :note => note, :id => self.id, :field => field , :created_at => Time.now.utc, :created_by => created_by, :updated_at => Time.now.utc
  end

  def update_note id, note, updated_by=nil
    ActiveMetadata.notes.update({:_id => id}, {"$set" => {:note => note, :updated_at => Time.now.utc, :updated_by => updated_by}})
  end

  def notes_for field
    ActiveMetadata.notes.find({:id => self.id, :field => field}).to_a
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
