class Watcher
  include Mongoid::Document

  belongs_to :label

  field :owner_id, :type => Integer

  def notify_changes(matched_label, values, model_class, model_id)
    return unless label.name == matched_label

    create_inbox_alert(User.find(owner_id).inbox, matched_label, values, model_class, model_id)
  end

  def create_inbox_alert(inbox, label, values, model_class, model_id)
    Message.create do |message|
      message.label = label
      message.model_class = model_class
      message.model_id = model_id
      message.alert_type = :model_value_changed
      message.old_value = values.first
      message.new_value = values.last
      message.content = nil?
      message.inbox_id = inbox.id
    end 
  end
end
