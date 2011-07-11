class AddPackageTimestampIndexes < ActiveRecord::Migration
  def self.up
    add_index :packages, :created_at
    add_index :packages, :updated_at
  end

  def self.down
    remove_index :packages, :created_at
    remove_index :packages, :updated_at
  end
end
