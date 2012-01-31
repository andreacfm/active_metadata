class ActiveMetadataMigrations < ActiveRecord::Migration
  def self.up

    create_table :active_metadata_notes do |t|
      t.text :note
      t.string :label
      t.string :document_class
      t.integer :document_id
      t.integer :created_by
      t.integer :updated_by
      t.boolean :starred
      t.timestamps
    end

    add_index :active_metadata_notes, :document_id
    add_index :active_metadata_notes, :label
    add_index :active_metadata_notes, :updated_at
    add_index :active_metadata_notes, :document_class

    create_table :active_metadata_histories do |t|
      t.text :value
      t.string :label
      t.string :document_class
      t.integer :document_id
      t.integer :created_by
      t.timestamps
    end

    add_index :active_metadata_histories, :document_id
    add_index :active_metadata_histories, :label
    add_index :active_metadata_histories, :created_at
    add_index :active_metadata_histories, :document_class

    create_table :active_metadata_attachments do |t|
      t.string :label
      t.integer :document_id
      t.string :document_class
      t.integer :created_by
      t.integer :updated_by
      t.integer :counter
      t.string :attach_file_name
      t.string :attach_content_type
      t.integer :attach_file_size
      t.datetime :attach_updated_at
      t.boolean :starred
      t.timestamps
    end

    add_index :active_metadata_attachments, :document_id
    add_index :active_metadata_attachments, :label
    add_index :active_metadata_attachments, :attach_updated_at
    add_index :active_metadata_attachments, :document_class

    create_table :active_metadata_watchers do |t|
      t.integer :owner_id
      t.string :label
      t.string :document_class
      t.integer :document_id
      t.timestamps
    end

    add_index :active_metadata_watchers, :document_id
    add_index :active_metadata_watchers, :label
    add_index :active_metadata_watchers, :owner_id
    add_index :active_metadata_watchers, :created_at

  end

  def self.down
    drop_table :active_metadata_notes
    drop_table :active_metadata_histories
    drop_table :active_metadata_attachments
    drop_table :active_metadata_watchers
  end

end