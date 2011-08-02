class Watcher
  include Mongoid::Document

  embedded_in :label

  field :owner_id, :type => Integer

  # t.string :label
  # t.string :object_class
  # t.integer :object_id
  # t.string :alert_type
  # t.string :old_value
  # t.string :new_value
  # t.text :content
  # t.integer :user_id
  # t.timestamps


  def notify_changes(matched_label, values)
    return unless label.name == matched_label

    create_inbox_alert(User.find(owner_id), matched_label, values)
  end

  def create_inbox_alert(user, label, values)      
    Inbox.create do |inbox|
      inbox.label = label
      inbox.model_class = self.class
      inbox.model_id = self.id
      inbox.alert_type = :model_value_changed
      inbox.old_value = values.first
      inbox.new_value = values.last
      inbox.content = nil?
      inbox.user_id = self.owner_id
    end 
  end
end
