class Version < ActiveRecord::Base
  belongs_to :package

  has_many :documents,    :dependent => :destroy, :order => :path, :extend => Document::Assoc
  has_many :dependencies, :dependent => :destroy
  has_many :dependees,    :dependent => :destroy, :foreign_key => :dependency_id, :class_name => 'Dependency'
  has_many :dependent_versions, :through => :dependencies, :uniq => true

  validates_presence_of   :number, :build
  validates_format_of     :number, :with => /^\d+\.\d+\.\d+(-[a-z0-9\.]+)?$/i, :allow_blank => true
  validates_uniqueness_of :number, :scope => :package_id,     :allow_blank => true
  validates_length_of     :build,  :maximum => 250.kilobytes, :allow_blank => true
  validate                :documents_check

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

  def documents=(*args)
    if args[0].is_a?(Hash)
      documents.clear
      args[0].each do |path, text|
        documents.build(:path => path.to_s, :text => text)
      end
    else
      super *args
    end
  end

protected

  def documents_check
    errors.delete(:documents)

    # transferring errors from the documents to this model
    documents.each do |doc|
      unless doc.valid?
        doc.errors.each do |key, value|
          errors.add("document '#{doc.path}'", "#{key} #{value}")
        end
      end
    end

    # ensuring that there is an index document
    if documents.select{|d| d.path == 'index'}.size != 1
      errors.add(:documents, "should have an index entry")
    end
  end

  def update_package_timestamps
    if package = Package.find_by_id(package_id)
      package.updated_at = Time.now
      package.save :validate => false
    end
  end
end
