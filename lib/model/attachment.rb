require "active_metadata/base"

class Attachment
  include Mongoid::Document
  include Mongoid::Paperclip

  embedded_in :label
  has_mongoid_attached_file :attach,
      :path  => "#{ActiveMetadata::CONFIG['attachment_base_path']}/:document_id/:label/:basename.:extension"

  field :value, :type => String
  field :created_by, :type => Integer

  Paperclip.interpolates :document_id do |attachment,style|
   attachment.instance.label.active_meta.document_id
  end

  Paperclip.interpolates :label do |attachment,style|
    attachment.instance.label.name
  end

end