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
      [
        "#{Rails.root}/public/index.html",
        "#{Rails.root}/public/packages.html",
        "#{Rails.root}/public/packages.json",
        "#{Rails.root}/public/packages/page*",
        "#{Rails.root}/public/packages/search*",
        "#{Rails.root}/public/packages/recent*",
        "#{Rails.root}/public/packages/updated*"
      ].each{ |f| FileUtils.rm_rf(f) }

      if package = version.package
        [
          "#{Rails.root}/packages/#{package.name}*",
          "#{ASSETS_DIR}/#{package.name}-#{version.number}.js",
          "#{ASSETS_DIR}/#{package.name}/#{version.number}/"
        ].each{ |f| FileUtils.rm_rf(f) }
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