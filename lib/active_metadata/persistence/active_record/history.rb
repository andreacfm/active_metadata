module ActiveMetadata::Persistence::ActiveRecord::History

  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end

  module InstanceMethods

    def save_history
      self.changes.each do |key, value|
        next if ActiveMetadata::CONFIG['history_skip_fields'].include?(key)        
        History.create! :value => value[1],:document_id => metadata_id,:label => key.to_s 
        self.send(:send_notification, key, value[0], value[1], :history_message) 
      end
    end

    def history_for field
      History.all(:conditions => {:document_id => metadata_id,:label => field}, :order => "created_at DESC")
    end

  end
end