class AddBuildToVersions < ActiveRecord::Migration
  def self.up
    add_column :versions, :build, :text
  end

  def self.down
    remove_column :versions, :build
  end
end