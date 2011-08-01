class CreateInboxes < ActiveRecord::Migration
  def self.up
    create_table :inboxes do |t|
      t.string :label
      t.string :object_class
      t.integer :object_id
      t.string :alert_type
      t.string :old_value
      t.string :new_value
      t.text :content
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :inboxes
  end
end
