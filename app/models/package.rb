class Package < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User'
  has_many   :versions, :order => 'number DESC', :dependent => :destroy

  attr_accessible :name, :description, :license, :version, :build, :readme

  validates_presence_of   :owner_id, :name, :description
  validates_format_of     :name, :with => /^[a-z0-9][a-z0-9\-]+[a-z0-9]$/, :allow_blank => true
  validates_uniqueness_of :name, :allow_blank => true

  before_validation :pass_data_to_version
  after_validation  :pass_errors_from_version

  scope :recent,  order('created_at DESC')
  scope :updated, order('updated_at DESC')

  def version
    (@version ||= versions.first).number
  end

  def version=(number)
    @version = if number.is_a?(Version)
      number
    else
      versions.find_by_number(number) or versions.build(:number => number)
    end
  end

  def build
    @build or @version.build if @version
  end

  def build=(str)
    @build = str
  end

  def readme
    @readme or @version.readme if @version
  end

  def readme=(str)
    @readme = str
  end

private

  def pass_data_to_version
    if @version
      @version.build  = @build
      @version.readme = @readme
    end
  end

  def pass_errors_from_version
    if @version && !@version.valid?
      @version.errors.each do |key, value|
        errors.add(key == :number ? :version : key, value)
      end
    end

    errors.delete :versions # don't need this one anymore
  end
end
