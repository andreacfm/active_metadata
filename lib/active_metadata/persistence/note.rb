module ActiveMetadata::Persistence::Note

  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end

  module InstanceMethods

    def create_note_for(field, note, starred=false, group=nil)
      ActiveMetadata::Note.create! :document_id => metadata_id, :document_class => metadata_class, :label => field.to_s, :note => note, :created_by => current_user_id, :starred => starred, :group => group

      reload_notes_cache_for field
      self.send(:send_notification, field, "", note, :note_message, current_user_id)
    end

    def update_note(id, note, starred=nil)
      n = ActiveMetadata::Note.find(id)
      old_value = n.note
      attributes = {:note => note, :updated_by => current_user_id, :updated_at => Time.now.utc}
      #mass assign starred inly if provided
      unless starred.nil?
        attributes[:starred] = starred
      end
      n.update_attributes! attributes
      reload_notes_cache_for n.label
      self.send(:send_notification, n.label, old_value, note, :note_message, current_user_id)
    end

    def notes_for(field, order_by="updated_at DESC")
      Rails.cache.fetch(notes_cache_key(field), :expires_in => ActiveMetadata::CONFIG['cache_expires_in'].minutes) do
        fetch_notes_for field, nil, order_by
      end
    end

    def find_note_by_id(id)
      ActiveMetadata::Note.find(id)
    end

    def create_notes_for(field, notes)
      notes.each { |note| create_note_for field, note }
    end

    def delete_note(id)
      note = ActiveMetadata::Note.find(id)
      old_value = note.note
      note.destroy
      reload_notes_cache_for note.label
      self.send(:send_notification, note.label, old_value, "", :note_message)
    end

    def has_notes_for field
      notes_for(field).size == 0 ? false : true
    end

    def count_notes_for field
      notes_for(field).size
    end

    # return all the starred notes for the current model and for any field
    # datas does not come from cache
    def starred_notes
      fetch_notes_for nil, true
    end

    # return all the starred notes for a particular field
    # datas does not come from cache
    def starred_notes_for(field)
      fetch_notes_for field, true
    end

    # return all starred notes for a given group
    def starred_notes_by_group(group, order_by="updated_at DESC")
      ActiveMetadata::Note.all(:conditions => {:starred => true, :group => group}, :order => order_by)
    end

    # star a note
    # reload the cache calling update
    def star_note(id)
      n = ActiveMetadata::Note.find(id)
      update_note id, n.note, true
    end

    # unstar a note
    # reload the cache calling update
    def unstar_note(id)
      n = ActiveMetadata::Note.find(id)
      update_note id, n.note, false
    end

    private

    def reload_notes_cache_for field
      Rails.cache.write(notes_cache_key(field), fetch_notes_for(field), :expires_in => ActiveMetadata::CONFIG['cache_expires_in'].minutes)
    end

    def fetch_notes_for(field, starred=nil, order_by="updated_at DESC")
      conditions = {:document_class => metadata_class, :document_id => metadata_id}
      conditions[:label] = field  unless field.nil?
      conditions[:starred] = starred  unless starred.nil?
      ActiveMetadata::Note.all(:conditions => conditions, :order => order_by)
    end

  end
end