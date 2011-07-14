class CreateVersions < ActiveRecord::Migration
  def self.up
    create_table :versions do |t|
      t.integer :package_id
      t.string  :number

      t.timestamps
    end

    add_index :versions, :package_id
    add_index :versions, :number
  end

  def self.down
    drop_table :versions
  end
end
