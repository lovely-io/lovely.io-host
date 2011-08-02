class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.integer :version_id
      t.string  :path
      t.text    :data

      t.timestamps
    end

    add_index :images, :version_id
    add_index :images, [:version_id, :path], :uniq => true
  end

  def self.down
    drop_table :images
  end
end
