class CreateAlertMessage < ActiveRecord::Migration
  def self.up
    drop_table :inboxes

    create_table :inboxes do |t|
      t.integer :user_id
    end
    
    create_table :alert_messages do |t|
      t.string :label
      t.string :model_class
      t.integer :model_id
      t.string :alert_type
      t.text :old_value
      t.text :new_value
      t.integer :inbox_id
      t.boolean :read
      
      t.timestamps
    end
  end

  def self.down
    drop_table :alert_messages
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
end
