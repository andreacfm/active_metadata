module ActiveMetadata::Attachment

  def self.extended klazz

    def klazz.path
      File.expand_path "#{ActiveMetadata::CONFIG['attachment_base_path']}/#{self.attachment_relative_path}/#{self.attachment_file_name}"
    end
  end

  module InstanceMethods
    def save_attachment_for field, file
      relative_path = "#{metadata_id}/#{field.to_s}"
      ActiveMetadata.safe_connection do
        ActiveMetadata.attachments.insert({
                                              :id => metadata_id,
                                              :field => field,
                                              :attachment_file_name => file.original_filename,
                                              :attachment_content_type => file.content_type,
                                              :attachment_size => file.size,
                                              :attachment_updated_at => Time.now.utc,
                                              :attachment_relative_path => relative_path
                                          })
      end
      write_attachment(relative_path, file)
    end

    def attachments_for field
      ActiveMetadata.safe_connection do
        to_open_struct ActiveMetadata.attachments.find({:field => field}).to_a do |os|
          os.send :extend, ActiveMetadata::Attachment
        end
      end
    end

    def delete_attachment id
      attachment = nil
      _id = id.class == String ? BSON::ObjectId(id) : id
      ActiveMetadata.safe_connection do
        attachment = ActiveMetadata.attachments.find_one({:_id => _id})
        ActiveMetadata.attachments.remove({:_id => _id})
      end
      File.delete File.expand_path "#{ActiveMetadata::CONFIG['attachment_base_path']}/#{attachment['attachment_relative_path']}/#{attachment['attachment_file_name']}"
    end

    def update_attachment id, newfile
      attachment = nil
      ActiveMetadata.safe_connection do
        attachment = ActiveMetadata.attachments.find_one({:_id => id})
        ActiveMetadata.attachments.update({:_id => id}, {"$set" => {
            :attachment_file_name => newfile.original_filename,
            :attachment_content_type => newfile.content_type,
            :attachment_size => newfile.size,
            :attachment_updated_at => Time.now.utc
        }})
      end
      File.delete File.expand_path "#{ActiveMetadata::CONFIG['attachment_base_path']}/#{attachment['attachment_relative_path']}/#{attachment['attachment_file_name']}"
      write_attachment attachment['attachment_relative_path'], newfile
    end

    private

    def write_attachment relative_path, file
      path = File.expand_path "#{ActiveMetadata::CONFIG['attachment_base_path']}/#{relative_path}"
      FileUtils.mkdir_p path
      File.open("#{path}/#{file.original_filename}", 'wb') { |f| f.write file.read }
    end


  end

end

