#
# Handles the cache cleanup after versions create/update
#
require 'fileutils'
class VersionsCacher < ActiveRecord::Observer
  observe :version

  def after_save(version)
    clean_cache(version)
    save_assets(version)
  end

  def after_delete(version)
    clean_cache
  end

protected

  def clean_cache(version)
    if version
      system "rake app:clean:packages"

      if package = version.package
        system "rake app:clean:packages PACKAGE=#{package.name} VERSION=#{version.number}"
      end
    end
  end

  def save_assets(version)
    unless version.build.blank? or !version.package
      File.open("#{ASSETS_DIR}/#{version.package.name}-#{version.number}.js", "w") do |f|
        f.write version.build
      end
    end
  end
end