class CreateHistory < ActiveRecord::Migration
  def self.up
    create_table :histories do |t|
      t.text :value
      t.string :label
      t.integer :document_id
      t.timestamps
    end

    add_index :histories, :document_id
    add_index :histories, :label
    add_index :histories, :created_at
        
  end

  def self.down
    drop_table :histories
  end

end