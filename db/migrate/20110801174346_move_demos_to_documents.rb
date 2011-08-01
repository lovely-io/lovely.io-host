class MoveDemosToDocuments < ActiveRecord::Migration
  def self.up
    Version.all.each do |version|
      unless version.demo.blank?
        Document.create! do |doc|
          doc.version = version
          doc.path    = 'demo'
          doc.text    = version.demo
        end
      end
    end

    remove_column :versions, :demo
  end

  def self.down
    add_column :versions, :demo, :text

    Document.where(:path => 'demo').all do |doc|
      doc.version.demo = doc.text
      doc.delete
    end
  end
end
