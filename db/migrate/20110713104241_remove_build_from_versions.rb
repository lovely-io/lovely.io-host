class RemoveBuildFromVersions < ActiveRecord::Migration
  def self.up
    remove_column :versions, :build
  end

  def self.down
    add_column :versions, :build, :text
  end
end
