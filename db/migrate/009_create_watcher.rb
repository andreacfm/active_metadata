class CreateWatcher < ActiveRecord::Migration
  def self.up
    create_table :watchers do |t|
      t.integer :owner_id
      t.string :label
      t.integer :document_id
      t.timestamps
    end

    add_index :watchers, :document_id
    add_index :watchers, :label
    add_index :watchers, :owner_id
    add_index :watchers, :created_at
        
  end

  def self.down
    drop_table :watchers
  end

end