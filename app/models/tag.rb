class Tag < ActiveRecord::Base
  has_and_belongs_to_many :packages, :order => 'packages.name', :uniq => true

  validates_presence_of   :name
  validates_uniqueness_of :name, :allow_blank => true
  validates_format_of     :name, :allow_blank => true, :with => /^[a-z0-9 ]+$/
end
