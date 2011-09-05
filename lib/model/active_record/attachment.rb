class Attachment < ActiveRecord::Base
  
  include ::Paperclip
  include ::Paperclip::Glue

  has_attached_file :attach,
      :path  => "#{ActiveMetadata::CONFIG['attachment_base_path']}/:document_id/:label/:id/:basename.:extension",
      :url  => "#{ActiveMetadata::CONFIG['attachment_base_url']}/:document_id/:label/:i/:basename.:extension"

  Paperclip.interpolates :document_id do |attachment,style|
   attachment.instance.document_id
  end

  Paperclip.interpolates :label do |attachment,style|
    attachment.instance.label
  end

end
