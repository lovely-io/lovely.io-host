class CreateShows < ActiveRecord::Migration
  def self.up
    create_table :shows do |t|
      t.integer  :author_id
      t.string   :uri
      t.string   :title
      t.text     :text

      t.timestamps
    end

    add_index :shows, [:author_id]
    add_index :shows, [:uri]
  end

  def self.down
    drop_table :shows
  end
end
