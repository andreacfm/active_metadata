module ActiveMetadata::Note

  module InstanceMethods

    def create_note_for(field, note, created_by=nil)
      raise RuntimeError, "The object id MUST be valued" unless self.id
      metadata = ActiveMeta.where(:document_id => metadata_id).and("labels.name" => field.to_s).first
      if metadata.nil?
        metadata = ActiveMeta.create!(:document_id => metadata_id)
        metadata.labels.create!(:name => field.to_s)
      end
      metadata.labels.where(:name => field.to_s).first.notes.create!(:note => note)
    end

    def update_note id, note, updated_by=nil
      ActiveMetadata.safe_connection do
        ActiveMetadata.notes.update({:_id => id}, {"$set" => {:note => note, :updated_at => Time.now.utc, :updated_by => updated_by}})
      end
    end

    def notes_for field
      ActiveMeta.where(:document_id => metadata_id).first.labels.where(:name => field.to_s).first.notes.to_a
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