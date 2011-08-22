class AddOggUrlToShows < ActiveRecord::Migration
  def self.up
    rename_column :shows, :movie_url, :mpg_url
    add_column :shows, :ogg_url, :string
    add_column :shows, :src_url, :string
    add_column :shows, :img_url, :string
  end

  def self.down
    remove_column :shows, :img_url
    remove_column :shows, :src_url
    remove_column :shows, :ogg_url
    rename_column :shows, :mpg_url, :movie_url
  end
end