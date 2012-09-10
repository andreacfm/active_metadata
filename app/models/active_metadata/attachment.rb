module ActiveMetadata

  class Attachment < ActiveRecord::Base
    self.table_name = "active_metadata_attachments"
    include ::Paperclip
    include ::Paperclip::Glue

    has_attached_file :attach,
                      :path => "#{ActiveMetadata::CONFIG['attachment_base_path']}/:model_class/:model_id/:label/:id/:basename.:extension",
                      :url => "#{ActiveMetadata::CONFIG['attachment_base_url']}/:model_class/:model_id/:label/:id/"

    Paperclip.interpolates :model_id do |attachment, style|
      attachment.instance.model_id
    end

    Paperclip.interpolates :label do |attachment, style|
      attachment.instance.label
    end

    Paperclip.interpolates :model_class do |attachment, style|
      attachment.instance.model_class
    end
    class << self

      def by_group(group, *args)
        options = args.extract_options!
        order_by = options.delete(:order_by) || "created_at DESC"
        ActiveMetadata::Attachment.all(:conditions => options.merge(:group => group), :order => order_by)
      end
    end
  end
end
