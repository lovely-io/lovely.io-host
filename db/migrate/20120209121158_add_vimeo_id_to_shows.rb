class AddVimeoIdToShows < ActiveRecord::Migration
  def self.up
    change_table :shows do |t|
      t.remove   :mpg_url
      t.remove   :ogg_url
      t.remove   :src_url
      t.remove   :img_url

      t.string   :vimeo_id
    end
  end

  def self.down
    change_table :shows do |t|
      t.string   :mpg_url
      t.string   :ogg_url
      t.string   :src_url
      t.string   :img_url

      t.remove   :vimeo_id
    end
  end
end
