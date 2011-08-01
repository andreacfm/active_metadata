module ActiveMetadata::History

  module InstanceMethods

    def save_history
      self.changes.each do |key, value|
        next if ActiveMetadata::CONFIG['history_skip_fields'].include?(key)
        
        label = ActiveMeta.find_or_create_by(:document_id => metadata_id).labels.find_or_create_by(:name => key.to_s)
        label.histories.create!(:value => value[1], :created_at => Time.now.utc)
      end
    end

    def history_for field
      meta = ActiveMeta.find_or_create_by(:document_id => metadata_id)
      
      label = meta.labels.find_or_create_by(:name => field.to_s)
      label.histories.desc(:created_at).to_a
    end

  end
end