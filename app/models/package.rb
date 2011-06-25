class Package < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User'
  has_many   :versions, :order => 'number DESC', :dependent => :destroy

  attr_accessible :name, :description, :version, :license

  validates_presence_of   :owner_id, :name, :description
  validates_format_of     :name, :with => /^[a-z0-9][a-z0-9\-]+[a-z0-9]$/, :allow_blank => true
  validates_uniqueness_of :name, :allow_blank => true
  #validate :version_check

  scope :recent,  order('created_at DESC')
  scope :updated, order('updated_at DESC')

  def version
    @version.number if @version = versions.first
  end

  def version=(number)
    @version = versions.build :number => number
  end

private

  def version_check
    if !@version
      errors.add(:version, "can't be blank")
    elsif !@version.valid?
      errors.add(:version, @version.errors[:number][0])
    end

    errors.delete :versions # removing the 'versions' errors list
  end
end
