class Document < ActiveRecord::Base
  belongs_to :version

  validates_presence_of   :version_id, :path, :text
  validates_uniqueness_of :path, :scope => :version_id

  scope :index, where(:path => 'index')
end
