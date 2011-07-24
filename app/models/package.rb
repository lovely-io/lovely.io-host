class Package < ActiveRecord::Base
  belongs_to :owner,    :class_name => 'User'
  has_many   :versions, :order => 'number ASC', :dependent => :destroy

  attr_accessible :manifest, :build, :docs

  validates_presence_of   :owner_id, :name, :description
  validates_format_of     :name, :with => /^[a-z0-9][a-z0-9\-]*[a-z0-9]$/, :allow_blank => true
  validates_uniqueness_of :name, :allow_blank => true
  validates_length_of     :description, :maximum => 250.bytes, :allow_blank => true
  validates_exclusion_of  :name, :in => RESERVED_PACKAGE_NAMES, :message => "is reserved"
  validate                :manifest_check

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
    @version
  end

  def version=(version)
    @version = version
  end

  def dependencies
    @dependencies
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

private

  def manifest_check
    errors.delete :versions # don't need this one anymore


    errors.add(:manifest, "is malformed") if @malformed_manifest
  end
end
