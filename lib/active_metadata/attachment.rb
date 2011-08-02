module ActiveMetadata::Attachment

  module InstanceMethods

    def save_attachment_for field, file
      label = ActiveMeta.find_or_create_by(:document_id => metadata_id).labels.find_or_create_by(:name => field.to_s)
      counter = label.attachments.count > 0 ? label.attachments.last.counter : 0
      attachment = Attachment.new :attach => file, :counter => (counter + 1)
      label.attachments << attachment
      label.save
    end

    def attachments_for field
      label = ActiveMeta.find_or_create_by(:document_id => metadata_id).labels.find_or_create_by(:name => field.to_s)
      label.attachments.desc(:attach_updated_at).to_a
    end

    def delete_attachment_for field,id
      ActiveMeta.find_or_create_by(:document_id => metadata_id).labels.find_or_create_by(:name => field.to_s).attachments.find(id).destroy
    end

    def update_attachment_for field, id, newfile
      a = ActiveMeta.find_or_create_by(:document_id => metadata_id).labels.find_or_create_by(:name => field.to_s).attachments.find(id)
      a.attach = newfile
      a.save
    end

  end

end

