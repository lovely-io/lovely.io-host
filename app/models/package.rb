class Package < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User'
  has_many   :versions, :order => 'number DESC', :dependent => :destroy

  attr_accessible :name, :description, :license, :version, :build, :readme, :dependencies

  validates_presence_of   :owner_id, :name, :description, :version
  validates_format_of     :name, :with => /^[a-z0-9][a-z0-9\-]*[a-z0-9]$/, :allow_blank => true
  validates_uniqueness_of :name, :allow_blank => true
  validates_length_of     :description,    :maximum => 250.bytes,     :allow_blank => true
  validates_length_of     :build, :readme, :maximum => 250.kilobytes, :allow_blank => true

  before_validation :pass_data_to_version
  after_validation  :pass_errors_from_version

  scope :recent,  order('created_at DESC')
  scope :updated, order('updated_at DESC')
  scope :like,    lambda{ |s| where("name LIKE ?", "%#{s}%") }

  def self.find(*args)
    if args.size == 1 && args[0].is_a?(String) && args[0] !=~ /^\d+$/
      find_by_name(args[0]) or raise(ActiveRecord::RecordNotFound)
    else
      super *args
    end
  end

  def to_param
    name
  end

  def version
    @version ||= versions.first
    @version.number if @version
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

  def dependencies
    @dependencies or @version.dependencies_hash if @version
  end

  def dependencies=(hash)
    @dependencies = hash
  end

  def save
    super and ((new_record? || !@version) ? true : @version.save)
  end

  # better json export
  def to_json
    {
      'name'         => name,
      'description'  => description,
      'author'       => owner.name,
      'license'      => license,
      'versions'     => versions.map(&:number),
      'dependencies' => dependencies || {},
      'created_at'   => created_at,
      'updated_at'   => updated_at
    }.to_json
  end

private

  def pass_data_to_version
    if @version
      @version.build  = @build
      @version.readme = @readme
      @version.dependencies_hash = @dependencies unless @dependencies.blank?
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
