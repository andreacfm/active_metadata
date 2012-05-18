module ActiveMetadata
  class Note < ActiveRecord::Base
    self.table_name = "active_metadata_notes"

    class << self

      def by_group(group, *args)
        options = args.extract_options!
        order_by = options.delete(:order_by) || "created_at DESC"
        ActiveMetadata::Note.all(:conditions => options.merge(:group => group), :order => order_by)
      end

    end

  end
end
