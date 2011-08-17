class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name
      t.timestamps
    end

    create_table :packages_tags, :id => false do |t|
      t.integer :package_id
      t.integer :tag_id
    end

    add_index :tags, :name, :uniq => true
    add_index :packages_tags, :package_id
    add_index :packages_tags, :tag_id
  end

  def self.down
    drop_table :packages_tags
    drop_table :tags
  end
end