class Version < ActiveRecord::Base
  MAX_IMAGES_COUNT = 8

  belongs_to :package

  has_many :images,       :dependent => :destroy
  has_many :documents,    :dependent => :destroy, :order => :path, :extend => Document::Assoc
  has_many :dependencies, :dependent => :destroy
  has_many :dependees,    :dependent => :destroy, :foreign_key => :dependency_id, :class_name => 'Dependency'
  has_many :dependent_versions, :through => :dependencies, :uniq => true, :order => 'versions.number'

  validates_presence_of   :number, :build
  validates_format_of     :number, :with => /^\d+\.\d+\.\d+(-[a-z0-9\.]+)?$/i, :allow_blank => true
  validates_uniqueness_of :number, :scope => :package_id,     :allow_blank => true
  validates_length_of     :build,  :maximum => 250.kilobytes, :allow_blank => true
  validate                :documents_check, :images_check

  after_save :patch_build_with_images
  after_save :update_package_timestamps

  def dependencies_hash
    {}.tap do |hash|
      dependent_versions.includes(:package).each do |version|
        hash[version.package.name] = version.number
      end
    end
  end

  def dependencies_hash=(hash)
    (hash||{}).each do |name, number|
      if package = Package.find_by_name(name)
        number  = number.gsub /^[^\d]+/, '' # removing the '>=' and stuff
        if version = Version.find_by_package_id_and_number(package, number)
          dependencies.build :dependent_version => version
        end
      end
    end
  end

  alias_method :documents_super, :documents=
  alias_method :images_super,    :images=

  def documents=(*args)
    if args[0].is_a?(Hash)
      args[0] = args[0].map do |path, text|
        unless text.blank?
          documents.build(:path => path.to_s, :text => text)
        end
      end.compact
    end

    documents_super *args
  end

  def images=(*args)
    if args[0].is_a?(Hash)
      args[0] = args[0].map do |path, data|
        images.build(:path => path.to_s, :data => data)
      end
    end

    images_super *args
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

  def images_check
    errors.delete(:images)

    # transferring the image errors
    images.each do |img|
      unless img.valid?
        img.errors.each do |key, value|
          errors.add("image '#{img.path}'", "#{key} #{value}")
        end
      end
    end

    if images.size > MAX_IMAGES_COUNT
      errors.add(:base, "Too many images, consider using sprites")
    end
  end

  def patch_build_with_images
    return unless package && Package.cdn_url && !@just_patched

    cdn_url = Package.cdn_url
    cdn_url = cdn_url.slice(0, cdn_url.size - 2) if cdn_url.ends_with?('/')
    cdn_url += "/#{package.to_param}/#{number}"

    images.each do |image|
      path = image.path
      path = path.slice(1, path.size) if path.starts_with?('/')

      self.build = self.build.gsub(/('|")[\/]*images\/#{Regexp.escape(path)}\1/) do |match|
        "#{$1}#{cdn_url}/#{path}#{$1}"
      end
    end

    @just_patched = true
    save :validate => false
  end

  def update_package_timestamps
    if package = Package.find_by_id(package_id)
      package.updated_at = Time.now
      package.save :validate => false
    end
  end
end
