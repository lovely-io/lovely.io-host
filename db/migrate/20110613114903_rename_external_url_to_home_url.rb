class RenameExternalUrlToHomeUrl < ActiveRecord::Migration
  def self.up
    rename_column :users, :external_url, :home_url
  end

  def self.down
    rename_column :users, :home_url, :external_url
  end
end