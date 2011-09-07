class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.text :note
      t.string :label
      t.integer :document_id
      t.integer :created_by
      t.integer :updated_by      
      t.timestamps
    end

    add_index :notes, :document_id
    add_index :notes, :label
    add_index :notes, :updated_at
        
  end

  def self.down
    drop_table :notes
  end

end