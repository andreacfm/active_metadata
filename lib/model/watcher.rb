class Watcher
  include Mongoid::Document

  embedded_in :label

  field :owner_id, :type => Integer

  def notify_changes(matched_label, values)    
    return unless label.name == matched_label

    create_inbox_alert(User.find(owner_id).inbox, matched_label, values)
  end

  def create_inbox_alert(inbox, label, values)      
    Message.create do |message|
      message.label = label
      message.model_class = self.class
      message.model_id = self.id
      message.alert_type = :model_value_changed
      message.old_value = values.first
      message.new_value = values.last
      message.content = nil?
      message.inbox_id = inbox.id
    end 
  end
end
