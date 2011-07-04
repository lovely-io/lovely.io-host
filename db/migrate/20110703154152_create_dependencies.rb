class CreateDependencies < ActiveRecord::Migration
  def self.up
    create_table :dependencies do |t|
      t.integer :version_id     # owner version id
      t.integer :dependency_id  # dependent version id

      t.timestamps
    end

    add_index :dependencies, :version_id
    add_index :dependencies, :dependency_id
  end

  def self.down
    drop_table :dependencies
  end
end
