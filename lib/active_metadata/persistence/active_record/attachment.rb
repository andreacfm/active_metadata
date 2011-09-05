module ActiveMetadata::Persistence::ActiveRecord::Attachment

  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end

  module InstanceMethods

    def save_attachment_for(field, file)      
      attachment = Attachment.create! :document_id => metadata_id, :label => field, :attach => file      
      self.send(:send_notification, field, "", attachment.attach.original_filename)
    end

    def attachments_for(field)
      Attachment.all(:conditions => {:document_id => metadata_id,:label => field}, :order => "attach_updated_at DESC")
    end

    def delete_attachment_for(field,id)
      a = Attachment.find(id)
      filename = a.attach.original_filename
      a.destroy      
      self.send(:send_notification, field, filename, "")
    end

    def update_attachment_for(field, id, newfile)
      a = Attachment.find(id)
      old_filename = a.attach.original_filename
      a.attach = newfile
      a.save                                            
      new_filename = a.attach.original_filename
      
      self.send(:send_notification, field, old_filename, new_filename)
    end

  end

end
