module ActiveMetadata::Persistence::ActiveRecord::Attachment

  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end

  module InstanceMethods

    def save_attachment_for(field, file, starred=false)
      attachment = Attachment.create! :document_class => metadata_class, :document_id => metadata_id, :label => field, :attach => file,
                                      :starred => starred, :created_by => current_user_id
      reload_attachments_cache_for field 
      self.send(:send_notification, field, "", attachment.attach.original_filename, :attachment_message, current_user_id)
    end

    def attachments_for(field)
      Rails.cache.fetch(attachments_cache_key(field), :expires_in => ActiveMetadata::CONFIG['cache_expires_in'].minutes) do
        fetch_attachments_for field   
      end  
    end

    def delete_attachment_for(field,id)
      a = Attachment.find(id)
      filename = a.attach.original_filename
      a.destroy      
      reload_attachments_cache_for field 
      self.send(:send_notification, field, filename, "", :attachment_message)
    end

    def update_attachment(id, newfile, starred=nil)
      a = Attachment.find(id)
      old_filename = a.attach.original_filename
      a.attach = newfile
      a.updated_by = current_user_id
      a.starred = starred if !starred.nil?
      a.save
      new_filename = a.attach.original_filename

      reload_attachments_cache_for a.label
      self.send(:send_notification, a.label, old_filename, new_filename, :attachment_message, current_user_id)
    end

    def has_attachments_for field
      attachments_for(field).size == 0 ? false : true
    end

    def find_attachment_by_id(id)
      Attachment.find(id)
    end

    # not cached
    def starred_attachments_for(field)
      fetch_attachments_for field,true
    end

    def star_attachment(id)
      n = Attachment.find(id)
      update_attachment id,n.attach,true
    end

    def unstar_attachment(id)
      n = Attachment.find(id)
      update_attachment id,n.attach,false
    end

    private
    
    def reload_attachments_cache_for field
      Rails.cache.write(attachments_cache_key(field),fetch_attachments_for(field), :expires_in => ActiveMetadata::CONFIG['cache_expires_in'].minutes )     
    end  
    
    def fetch_attachments_for field, starred=nil
      conditions = {:document_class => metadata_class, :document_id => metadata_id,:label => field}
      conditions[:starred] = starred if !starred.nil?
      Attachment.all(:conditions => conditions , :order => "attach_updated_at DESC")
    end  

  end

end
