class Version < ActiveRecord::Base
  belongs_to :package

  has_many :documents,    :dependent => :destroy, :order => :path
  has_many :dependencies, :dependent => :destroy
  has_many :dependees,    :dependent => :destroy, :foreign_key => :dependency_id, :class_name => 'Dependency'
  has_many :dependent_versions, :through => :dependencies, :uniq => true

  validates_presence_of   :number, :readme
  validates_presence_of   :build,  :on => :create
  validates_format_of     :number, :with => /^\d+\.\d+\.\d+(-[a-z0-9\.]+)?$/i, :allow_blank => true
  validates_uniqueness_of :number, :scope => :package_id, :allow_blank => true

  after_save :update_package_timestamps

  def dependencies_hash
    {}.tap do |hash|
      dependent_versions.includes(:package).each do |version|
        hash[version.package.name] = version.number
      end
    end
  end

  def dependencies_hash=(hash)
    self.dependent_versions = (hash||{}).map do |name, number|
      if package = Package.find_by_name(name)
        number = number.gsub /^[^\d]+/, '' # removing the '>=' and stuff
        Version.find_by_package_id_and_number(package, number)
      end
    end.compact
  end

  def readme
    @doc ||= documents.index.first
    @doc.text if @doc
  end

  def readme=(text)
    @doc = if new_record?
      documents.index.build :text => text
    else
      documents.index.first.update_attributes :text => text
    end
  end

protected

  def update_package_timestamps
    if package = Package.find_by_id(package_id)
      package.updated_at = Time.now
      package.save :validate => false
    end
  end
end
