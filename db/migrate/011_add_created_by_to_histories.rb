class AddCreatedByToHistories < ActiveRecord::Migration
  def self.up
    add_column :histories, :created_by, :integer
  end

  def self.down
    remove_column :histories, :created_by
  end

end