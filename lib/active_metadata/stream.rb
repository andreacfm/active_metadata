module ActiveMetadata
  module Stream

    def self.included(base)
      base.send :include, InstanceMethods
    end
    class << self
      # same as #stream_for but not filtered by field
      def by_group group, *args
        options = args.extract_options!
        order_by = options.delete(:order_by) || :created_at
        sort_stream(collect_stream_items_by_group(group, options), order_by)
      end

      def sort_stream stream, order_by
        stream.sort { |a, b| a.send(order_by) <=> b.send(order_by) }
      end

      def collect_stream_items_by_group group, options
        res = []
        ActiveMetadata::CONFIG['streamables'].each do |model|
          res.concat "ActiveMetadata::#{model.to_s.capitalize}".to_class.send(:by_group, group, options).collect { |el| el }
        end
        res
      end
    end

    module InstanceMethods

      # return the streamables items by field in an ordered array
      # ActiveMetadata::CONFIG['streamables'] defines what models will be retrieved
      def stream_for(field, order_by = :created_at)
        ActiveMetadata::Stream.sort_stream(collect_stream_data(field), order_by)
      end

      def collect_stream_data field
        res = []
        ActiveMetadata::CONFIG['streamables'].each do |model|
          res.concat self.send(stream_collect_method(model.to_s), field).collect { |el| el }
        end
        res
      end

      def stream_collect_method model
        model.to_s == 'note' ? 'notes_for' : 'attachments_for'
      end

    end
  end
end