#
# Handles the cache cleanup after versions create/update
#
class VersionsCacher < ActiveRecord::Observer
  observe :version

  def after_save(version)
    clean_cache(version)
  end

  def after_delete(version)
    clean_cache
  end

protected

  def clean_cache(version)
    if Rails.env == 'production'
      system "rake app:clean:packages"

      if version && package = version.package
        system "rake app:clean:packages PACKAGE=#{package.name} VERSION=#{version.number}"
      end
    end
  end
end