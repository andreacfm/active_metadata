module ActiveMetadata::Persistence::Mongoid::Attachment

  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end

  module InstanceMethods

    def save_attachment_for(field, file)
      label = ActiveMeta.find_or_create_by(:document_id => metadata_id).labels.find_or_create_by(:name => field.to_s)
      counter = label.attachments.count > 0 ? label.attachments.last.counter : 0
      attachment = Attachment.new(:attach => file, :counter => (counter + 1))
      label.attachments << attachment
      label.save
      
      self.send(:send_notification, field, "", attachment.attach.original_filename)
    end

    def attachments_for(field)
      label = ActiveMeta.find_or_create_by(:document_id => metadata_id).labels.find_or_create_by(:name => field.to_s)
      label.attachments.desc(:attach_updated_at).to_a
    end

    def delete_attachment_for(field,id)
      a = ActiveMeta.find_or_create_by(:document_id => metadata_id).labels.find_or_create_by(:name => field.to_s).attachments.find(id)
      filename = a.attach.original_filename
      a.destroy
      
      self.send(:send_notification, field, filename, "")
    end

    def update_attachment_for(field, id, newfile)
      a = ActiveMeta.find_or_create_by(:document_id => metadata_id).labels.find_or_create_by(:name => field.to_s).attachments.find(id)
      old_filename = a.attach.original_filename
      a.attach = newfile
      a.save                                            
      new_filename = a.attach.original_filename
      
      self.send(:send_notification, field, old_filename, new_filename)
    end

  end

end

