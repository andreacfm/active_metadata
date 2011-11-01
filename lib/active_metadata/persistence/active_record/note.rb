module ActiveMetadata::Persistence::ActiveRecord::Note

  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end

  module InstanceMethods
    
    def create_note_for(field, note)      
      Note.create! :document_id => metadata_id, :document_class => metadata_class, :label => field.to_s,:note => note, :created_by => current_user_id
      reload_notes_cache_for field 
      self.send(:send_notification, field, "", note, :note_message, current_user_id) 
    end

    def update_note(id, note)
      n = Note.find(id)
      old_value = n.note
      n.update_attributes! :note => note, :updated_by => current_user_id, :updated_at => Time.now.utc     
      reload_notes_cache_for n.label 
      self.send(:send_notification, n.label, old_value, note, :note_message, current_user_id)
    end

    def notes_for(field)
      Rails.cache.fetch(notes_cache_key(field), :expires_in => ActiveMetadata::CONFIG['cache_expires_in'].minutes) do
        fetch_notes_for field       
      end    
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
      reload_notes_cache_for field 
      self.send(:send_notification, field, old_value, "", :note_message)
    end
    
    def has_notes_for field      
      notes_for(field).size == 0 ? false : true
    end
    
    private
    
    def reload_notes_cache_for field
      Rails.cache.write(notes_cache_key(field),fetch_notes_for(field), :expires_in => ActiveMetadata::CONFIG['cache_expires_in'].minutes )     
    end  
    
    def fetch_notes_for field
      Note.all(:conditions => {:label => field, :document_class => metadata_class, :document_id => metadata_id}, :order => "updated_at DESC" )
    end  
        
  end
end