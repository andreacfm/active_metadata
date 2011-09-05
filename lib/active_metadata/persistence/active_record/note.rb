module ActiveMetadata::Persistence::ActiveRecord::Note

  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end

  module InstanceMethods
    
    def create_note_for(field, note, created_by=nil)
      Note.create! :document_id => metadata_id,:label => field.to_s,:note => note, :created_by => created_by    
                                                     
      # BEWARE: I'm not checking the send_notification method existence
      # this notification should be asynch
      self.send(:send_notification, field, "", note) 
    end

    def update_note(id, note, updated_by=nil)
      n = Note.find(id)
      old_value = n.note
      n.update_attributes! :note => note, :updated_by => updated_by, :updated_at => Time.now.utc
      
      self.send(:send_notification, n.label, old_value, note)
    end

    def notes_for(field)
      Note.all(:conditions => {:label => field, :document_id => metadata_id}, :order => "updated_at DESC" )
    end

    def note_for(field,id)
      Note.find(id)
    end      
    
    def create_notes_for(field,notes)
      notes.each { |note| create_note_for field, note }
    end

    def delete_note_for(field,id)
      n = Note.find(id)
      old_value = n.note
      n.destroy
      self.send(:send_notification, field, old_value, "")
    end
  end
end