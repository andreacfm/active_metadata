module TestDb

  def self.up
    ActiveRecord::Base.connection.create_table :documents, force: true do |t|
      t.string :name
      t.string :surname
      t.boolean :keep_alive
      t.datetime :date
      t.decimal :price, precision: 6, scale: 2
      t.decimal :average, precision: 6, scale: 3
      t.timestamps
    end

    ActiveRecord::Base.connection.create_table :sections, force: true do |t|
      t.string :title
      t.integer :document_id
      t.integer :chapter_id
      t.timestamps
    end

    ActiveRecord::Base.connection.create_table :chapters, force: true do |t|
      t.string :title
      t.timestamps
    end

    ActiveRecord::Base.connection.create_table :users, force: true do |t|
      t.string :email
      t.string :firstname
      t.string :lastname
      t.timestamps
    end
  end

  def self.down
    ActiveRecord::Base.connection.drop_table :users
    ActiveRecord::Base.connection.drop_table :chapters
    ActiveRecord::Base.connection.drop_table :sections
    ActiveRecord::Base.connection.drop_table :documents
  end

end
