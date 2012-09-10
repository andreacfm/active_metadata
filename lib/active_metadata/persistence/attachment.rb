module ActiveMetadata::Persistence::Attachment

  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end

  module InstanceMethods

    def save_attachment_for(field, file, starred=false, group=nil)
      attachment = ActiveMetadata::Attachment.create!(
              :model_class => metadata_class,
              :model_id => metadata_id,
              :label => field,
              :attach => file,
              :starred => !!starred,
              :created_by => current_user_id,
              :group => group)

      reload_attachments_cache_for field
      self.send(:send_notification, field, "", attachment.attach.original_filename, :new_attachment_message, current_user_id)
    end

    def attachments_for(field, order_by="updated_at DESC")
      Rails.cache.fetch(attachments_cache_key(field), :expires_in => ActiveMetadata::CONFIG['cache_expires_in'].minutes) do
        fetch_attachments_for field, nil, order_by
      end
    end

    def delete_attachment(id)
      a = ActiveMetadata::Attachment.find(id)
      filename, created_by = a.attach.original_filename, a.created_by
      a.destroy
      reload_attachments_cache_for a.label
      self.send(:send_notification, a.label, filename, "", :delete_attachment_message, created_by)
    end

    # Update an attachment replacing the old file
    # Fires a notification.
    # When is used to star or unstar fires a notification of the correct type
    # The cache is reloaded any time an operation is completed
    def update_attachment(id, newfile, *args)
      options = args.last.is_a?(Hash) ? args.last : {}
      options[:message_type] ||= :update_attachment_message

      a = ActiveMetadata::Attachment.find(id)
      old_filename = a.attach.original_filename
      a.attach = newfile
      a.updated_by = current_user_id

      #mass assign starred inly if provided
      unless options[:starred].nil?
        a[:starred] = options[:starred]
        options[:message_type] = options[:starred] ? :star_attachment_message : :unstar_attachment_message
      end

      a.save!
      new_filename = a.attach.original_filename
      reload_attachments_cache_for a.label

      self.send(:send_notification, a.label, old_filename, new_filename, options[:message_type], current_user_id)
    end

    def has_attachments_for field
      attachments_for(field).size == 0 ? false : true
    end

    def count_attachments_for field
      attachments_for(field).size
    end

    def find_attachment_by_id(id)
      ActiveMetadata::Attachment.find(id)
    end

    # return all the starred notes for the current model and for any field
    # datas does not come from cache
    def starred_attachments
      fetch_attachments_for nil, true
    end

    def starred_attachments_for(field)
      fetch_attachments_for field, true
    end

    def star_attachment(id)
      n = ActiveMetadata::Attachment.find(id)
      update_attachment id, n.attach, starred: true
    end

    def unstar_attachment(id)
      n = ActiveMetadata::Attachment.find(id)
      update_attachment id, n.attach, starred: false
    end

    private

    def reload_attachments_cache_for field
      #Rails.cache.clear
      Rails.cache.write(attachments_cache_key(field), fetch_attachments_for(field), :expires_in => ActiveMetadata::CONFIG['cache_expires_in'].minutes)
    end

    def fetch_attachments_for(field, starred=nil, order_by="updated_at DESC")
      conditions = {:model_class => metadata_class, :model_id => metadata_id}
      conditions[:label] = field unless field.nil?
      conditions[:starred] = starred unless starred.nil?
      ActiveMetadata::Attachment.all(:conditions => conditions, :order => order_by)
    end

  end

end
