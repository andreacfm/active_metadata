class Watcher
  include Mongoid::Document

  belongs_to :label

  field :owner_id, :type => Integer

  def notify_changes(matched_label, old_value, new_value, model_class, model_id)
    create_inbox_alert(User.find(owner_id).inbox, matched_label, old_value, new_value, model_class, model_id)
  end

  def create_inbox_alert(inbox, label, old_value, new_value, model_class, model_id)
    Message.create! do |message|
      message.label = label
      message.model_class = model_class.to_s
      message.model_id = model_id
      message.alert_type = :model_value_changed
      message.old_value = old_value
      message.new_value = new_value
      message.inbox_id = inbox.id
      message.read = false
    end 
  end
end
