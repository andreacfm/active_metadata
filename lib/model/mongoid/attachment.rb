class Attachment
  include Mongoid::Document
  include Mongoid::Paperclip

  belongs_to :label
  has_mongoid_attached_file :attach,
      :path  => "#{ActiveMetadata::CONFIG['attachment_base_path']}/:document_id/:label/:counter/:basename.:extension",
      :url  => "#{ActiveMetadata::CONFIG['attachment_base_url']}/:document_id/:label/:counter/:basename.:extension"

  field :created_by, :type => Integer
  field :counter, :type => Integer

  Paperclip.interpolates :document_id do |attachment,style|
   attachment.instance.label.active_meta.document_id
  end

  Paperclip.interpolates :label do |attachment,style|
    attachment.instance.label.name
  end

  Paperclip.interpolates :counter do |attachment,style|
    attachment.instance.counter
  end

end