class Package < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User'

  validates_presence_of   :owner_id, :name, :description
  validates_format_of     :name, :with => /^[a-z0-9][a-z0-9\-]+[a-z0-9]$/, :allow_blank => true
  validates_uniqueness_of :name, :allow_blank => true

end
