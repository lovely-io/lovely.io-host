class AddDemoToVersions < ActiveRecord::Migration
  def self.up
    add_column :versions, :demo, :text
  end

  def self.down
    remove_column :versions, :demo
  end
end