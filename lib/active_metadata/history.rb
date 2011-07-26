module ActiveMetadata::History

  module InstanceMethods

    def save_history
      self.changes.each do |key, value|
        next if ActiveMetadata::CONFIG['history_skip_fields'].include?(key)
        ActiveMetadata.safe_connection do
          ActiveMetadata.history.insert :id => metadata_id, :field => key, :value => value[1], :created_at => Time.now.utc
        end
      end
    end

    def history_for field
      ActiveMetadata.safe_connection do
      to_open_struct  ActiveMetadata.history.find({:id => metadata_id, :field => field}, {:sort => [[:created_at, 'descending']]}).to_a
      end
    end

  end
end