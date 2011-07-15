class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      t.integer :author_id
      t.string  :uri
      t.string  :title
      t.text    :text

      t.timestamps
    end

    add_index :news, :uri, :uniq => true
    add_index :news, :author_id
  end

  def self.down
    drop_table :news
  end
end
