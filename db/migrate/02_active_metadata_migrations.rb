class ActiveMetadataMigrations < ActiveRecord::Migration
  def self.up

    create_table :notes do |t|
      t.text :note
      t.string :label
      t.string :document_class
      t.integer :document_id
      t.integer :created_by
      t.integer :updated_by
      t.timestamps
    end

    add_index :notes, :document_id
    add_index :notes, :label
    add_index :notes, :updated_at
    add_index :notes, :document_class

    create_table :histories do |t|
      t.text :value
      t.string :label
      t.string :document_class
      t.integer :document_id
      t.integer :created_by
      t.timestamps
    end

    add_index :histories, :document_id
    add_index :histories, :label
    add_index :histories, :created_at
    add_index :histories, :document_class

    create_table :attachments do |t|
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
      t.timestamps
    end

    add_index :attachments, :document_id
    add_index :attachments, :label
    add_index :attachments, :attach_updated_at
    add_index :attachments, :document_class

    create_table :watchers do |t|
      t.integer :owner_id
      t.string :label
      t.string :document_class
      t.integer :document_id
      t.timestamps
    end

    add_index :watchers, :document_id
    add_index :watchers, :label
    add_index :watchers, :owner_id
    add_index :watchers, :created_at

  end

  def self.down
    drop_table :notes
    drop_table :histories
	drop_table :attachments
	drop_table :watchers
  end

end