class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.integer :version_id
      t.string  :path
      t.text    :text

      t.timestamps
    end

    add_index :documents, :version_id
    add_index :documents, [:version_id, :path]

    Version.all.each do |version|
      Document.create!({
        :version => version,
        :path    => 'index',
        :text    => version.readme
      })
    end

    remove_column :versions, :readme
  end

  def self.down
    add_column :versions, :readme, :text

    Document.all.each do |doc|
      if doc.path == 'index'
        Version.find(doc.version_id).update_attribute(:readme, doc.text)
      end
    end

    drop_table :documents
  end
end
