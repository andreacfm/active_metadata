module ActiveMetadata::Note

  module InstanceMethods

    def create_note_for(field, note, created_by=nil)
      raise RuntimeError, "The object id MUST be valued" unless self.id
      ActiveMetadata.safe_connection do
        ActiveMetadata.notes.insert :note => note, :id => metadata_id, :field => field, :created_at => Time.now.utc, :created_by => created_by, :updated_at => Time.now.utc
      end
    end

    def update_note id, note, updated_by=nil
      ActiveMetadata.safe_connection do
        ActiveMetadata.notes.update({:_id => id}, {"$set" => {:note => note, :updated_at => Time.now.utc, :updated_by => updated_by}})
      end
    end

    def notes_for field
      ActiveMetadata.safe_connection do
        to_open_struct ActiveMetadata.notes.find({:id => metadata_id, :field => field}, {:sort => [[:updated_at, 'descending']]}).to_a
      end
    end

    def create_notes_for field, notes
      notes.each do |note|
        create_note_for field, note
      end
    end

    def delete_note id
      _id = id.class == String ? BSON::ObjectId(id) : id
      ActiveMetadata.safe_connection do
        ActiveMetadata.notes.remove({:_id => _id})
      end
    end

  end
end