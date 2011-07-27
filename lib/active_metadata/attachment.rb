module ActiveMetadata::Attachment

  module InstanceMethods

    def save_attachment_for field, file
      label = ActiveMeta.find_or_create_by(:document_id => metadata_id).labels.find_or_create_by(:name => field.to_s)
      attachment = Attachment.new :attach => file
      label.attachments << attachment
      label.save
    end

    def attachments_for field
      label = ActiveMeta.find_or_create_by(:document_id => metadata_id).labels.find_or_create_by(:name => field.to_s)
      label.attachments.desc(:attach_updated_at).to_a
    end

    def delete_attachment id
      a = ActiveMeta.where("labels.attachments._id" => id).first.labels.first.attachments.first
      a.destroy
    end

    def update_attachment id, newfile
      a = ActiveMeta.where("labels.attachments._id" => id).first.labels.first.attachments.first
      a.attach = newfile
      a.save
    end

  end

end

