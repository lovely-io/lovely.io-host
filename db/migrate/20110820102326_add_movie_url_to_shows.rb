class AddMovieUrlToShows < ActiveRecord::Migration
  def self.up
    add_column :shows, :movie_url, :string
  end

  def self.down
    remove_column :shows, :movie_url
  end
end