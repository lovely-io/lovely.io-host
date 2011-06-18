class CreatePackages < ActiveRecord::Migration
  def self.up
    create_table :packages do |t|
      t.integer :owner_id
      t.string  :name
      t.text    :description

      t.timestamps
    end

    add_index :packages, :owner_id
    add_index :packages, :name, :uniq => true
  end

  def self.down
    drop_table :packages
  end
end
