class CreateTestResources < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.string :name
      t.string :surname
      t.timestamps
    end

    create_table :sections do |t|
      t.string :title
      t.integer :document_id
      t.timestamps
    end

    create_table :users do |t|
      t.string :email
      t.string :firstname
      t.string :lastname
      t.timestamps
    end

  end

  def self.down
    drop_table :documents
    drop_table :sections
    drop_table :users
  end
end
