module ActiveMetadata::Note

  module InstanceMethods
    def create_note_for(field, note, created_by=nil)
      raise RuntimeError, "The object id MUST be valued" unless self.id
      label = ActiveMeta.find_or_create_by(:document_id => metadata_id).labels.find_or_create_by(:name => field.to_s)
      label.notes.create!(:note => note, :created_by => created_by, :created_at => Time.now.utc, :updated_at => Time.now.utc)      
    end

    def update_note id, note, updated_by=nil
      n = ActiveMeta.where("labels.notes._id" => id).first.labels.first.notes.first
      n.update_attributes :note => note, :updated_by => updated_by, :updated_at => Time.now.utc
    end

    def notes_for field
      label = ActiveMeta.find_or_create_by(:document_id => metadata_id).labels.find_or_create_by(:name => field.to_s)
      label.notes.desc(:updated_at).to_a
    end

    def note_for field,id
      label = ActiveMeta.find_or_create_by(:document_id => metadata_id).labels.find_or_create_by(:name => field.to_s)
      label.notes.find(id)      
    end      
    
    def create_notes_for field, notes
      notes.each { |note| create_note_for field, note }
    end

    def delete_note_for field,id
      ActiveMeta.find_or_create_by(:document_id => metadata_id).labels.find_or_create_by(:name => field.to_s).notes.find(id).destroy
    end

  end
end