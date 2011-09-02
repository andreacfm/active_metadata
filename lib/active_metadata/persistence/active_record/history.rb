module ActiveMetadata::Persistence::ActiveRecord::History

  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end

  module InstanceMethods

    def save_history
      self.changes.each do |key, value|
        next if ActiveMetadata::CONFIG['history_skip_fields'].include?(key)        
        History.create! :value => value[1],:document_id => metadata_id,:label => key.to_s 
      end
    end

    def history_for field
      meta = ActiveMeta.find_or_create_by(:document_id => metadata_id)
      
      label = meta.labels.find_or_create_by(:name => field.to_s)
      label.histories.desc(:created_at).to_a
    end

  end
end