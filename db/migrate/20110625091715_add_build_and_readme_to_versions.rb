class AddBuildAndReadmeToVersions < ActiveRecord::Migration
  def self.up
    add_column :versions, :build,  :text
    add_column :versions, :readme, :text
  end

  def self.down
    remove_column :versions, :readme
    remove_column :versions, :build
  end
end