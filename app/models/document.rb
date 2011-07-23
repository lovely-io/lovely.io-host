class Document < ActiveRecord::Base
  belongs_to :version

  validates_presence_of   :version_id, :path, :text
  validates_uniqueness_of :path, :scope => :version_id
  validates_length_of     :text, :maximum => 250.kilobytes, :allow_blank => true

  scope :indeks, where(:path => 'index')
end
