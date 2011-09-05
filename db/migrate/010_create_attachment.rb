class CreateAttachment < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.string :label
      t.integer :document_id
      t.integer :created_by
      t.integer :updated_by
      t.integer :counter
      t.string :attach_file_name
      t.string :attach_content_type
      t.string :attach_file_size
      t.string :attach_updated_at
      t.timestamps
    end

    add_index :attachments, :document_id
    add_index :attachments, :label
    add_index :attachments, :attach_updated_at
        
  end

  def self.down
    drop_table :attachments
  end

end