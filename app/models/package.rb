class Package < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User'
  has_many   :versions, :order => 'number ASC', :dependent => :destroy

  attr_accessible :name, :description, :license, :version, :build,
    :dependencies, :manifest, :documentation, :home_url

  RESERVED_NAMES = %w(updated recent search page jquery mootools prototype)

  validates_presence_of   :owner_id, :name, :description, :version
  validates_format_of     :name, :with => /^[a-z0-9][a-z0-9\-]*[a-z0-9]$/, :allow_blank => true
  validates_uniqueness_of :name, :allow_blank => true
  validates_length_of     :description,  :maximum => 250.bytes,     :allow_blank => true

  validates_exclusion_of  :name, :in => RESERVED_NAMES, :message => "is reserved"

  after_validation  :pass_errors_from_version

  scope :recent,  order('packages.created_at DESC')
  scope :updated, order('packages.updated_at DESC')
  scope :like,    lambda{ |s| where("packages.name LIKE ?", "%#{s}%") }

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

  def dependencies
    @dependencies or @version.dependencies_hash if @version
  end

  def dependencies=(hash)
    @dependencies = hash
  end

  # properties mass-assignment via the package manifest
  MANIFEST_FIELDS = %w{
    name
    version
    license
    description
    dependencies
    home_url
  }
  def manifest=(json_string)
    begin
      JSON.parse(json_string).each do |key, value|
        if MANIFEST_FIELDS.include?(key.to_s) && value
          self.send("#{key}=", value)
        end
      end
    rescue
      @malformed_manifest = true
    end
  end

  def save(*args)
    super(*args) and ((new_record? || !@version) ? true : @version.save)
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

  def pass_errors_from_version
    if @version && !@version.valid?
      @version.errors.each do |key, value|
        errors.add(key == :number ? :version : key, value)
      end
    end

    errors.delete :versions # don't need this one anymore

    errors.add(:manifest, "is malformed") if @malformed_manifest
  end
end
