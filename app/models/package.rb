class Package < ActiveRecord::Base
  belongs_to :owner,    :class_name => 'User'
  has_many   :versions, :order => 'number ASC', :dependent => :destroy

  attr_accessible :manifest, :build, :documents, :images
  cattr_accessor  :cdn_url

  validates_presence_of   :owner_id, :name, :description
  validates_format_of     :name, :with => /^[a-z0-9][a-z0-9\-]*[a-z0-9]$/, :allow_blank => true
  validates_uniqueness_of :name, :allow_blank => true
  validates_length_of     :description, :maximum => 250.bytes, :allow_blank => true
  validates_exclusion_of  :name, :in => RESERVED_PACKAGE_NAMES, :message => "is reserved"
  validate                :manifest_check

  before_validation       :transfer_manifest_data

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
    @version ||= versions.last
  end

  def version=(version)
    @version = if version.is_a?(String)
      versions.find_by_number(version) or
      versions.build(:number => version)
    else
      version
    end
  end

  def dependencies
    @dependencies || version.dependencies_hash if version
  end

  def dependencies=(hash)
    @dependencies = hash
  end

  def documents
    @documents || version.documents if version
  end

  def documents=(hash)
    @documents = hash
  end

  def images
    @images || version.images if version
  end

  def images=(hash)
    @images = hash
  end

  def build
    @build || version.build if version
  end

  def build=(string)
    @build = string
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

  # better json export
  def to_json
    {
      'name'         => name,
      'description'  => description,
      'author'       => owner.name,
      'license'      => license,
      'home_url'     => home_url,
      'versions'     => versions.map(&:number),
      'dependencies' => dependencies || {},
      'created_at'   => created_at,
      'updated_at'   => updated_at
    }.to_json
  end

  def save(*args)
    super(*args) and (@version.save if args.empty? && @version)
  end

private

  def manifest_check
    errors.delete :versions # don't need this one anymore

    if @version && !@version.valid?
      @version.errors.each do |key, value|
        errors.add(key == :number ? :version : key, value)
      end
    elsif !@version
      errors.add(:version, "can't be blank")
    end

    errors.add(:manifest, "is malformed") if @malformed_manifest
  end

  def transfer_manifest_data
    if @version
      @version.dependencies_hash = @dependencies if @dependencies
      @version.documents         = @documents    if @documents
      @version.images            = @images       if @images
      @version.build             = @build        if @build
    end
  end
end
