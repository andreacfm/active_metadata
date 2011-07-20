class AddSurnameToDocument < ActiveRecord::Migration
  def self.up
    add_column :documents, :surname, :string
  end

  def self.down
    remove_column :documents, :surname
  end
end
