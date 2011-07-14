class AddHomeUrlStringToPackages < ActiveRecord::Migration
  def self.up
    add_column :packages, :home_url, :string
  end

  def self.down
    remove_column :packages, :home_url
  end
end