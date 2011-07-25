module ActiveMetadata::Attachment

    def self.extended klazz

      def klazz.path
        File.expand_path "#{ActiveMetadata::CONFIG['attachment_base_path']}/#{self.attachment_relative_path}/#{self.attachment_file_name}"
      end
    end

end
