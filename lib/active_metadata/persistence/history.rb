module ActiveMetadata::Persistence::History

  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end

  module InstanceMethods

    def save_history
      return if ActiveMetadata.skip_history?
      self.changes.each do |key, value|
        next if ActiveMetadata::CONFIG['history_skip_fields'].include?(key)
        ActiveMetadata::History.create! :value => value[1],:model_class => metadata_class, :model_id => metadata_id,:label => key.to_s, :created_by => current_user_id
        invalidate_history_cache_for key.to_s
        self.send(:send_notification, key, value[0], value[1], :history_message, current_user_id) unless skip_history_notification?
      end
    end

    def history_for field, order="created_at DESC"
      Rails.cache.fetch(history_cache_key(field), :expires_in => ActiveMetadata::CONFIG['cache_expires_in'].minutes) do
        fetch_histories_for field, order
      end
    end

    private

    def invalidate_history_cache_for field
      Rails.cache.delete history_cache_key(field)
    end  

    def fetch_histories_for field, order
      ActiveMetadata::History.all(:conditions => {:model_class => metadata_class, :model_id => metadata_id,:label => field}, :order => order)
    end  


  end
end