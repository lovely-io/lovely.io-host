namespace :app do
  desc "Dumps all the scripts and images"
  task :dump do
    require 'fileutils'
    require "#{Rails.root}/config/environment.rb"

    dir = "#{Rails.root}/tmp/cdn"

    FileUtils.mkdir_p dir

    Version.all.each do |version|
      File.open("#{dir}/#{version.package.name}-#{version.number}.js", "w") do |f|
        f.write version.build
      end
    end

    Image.all.each do |image|
      version = image.version
      package = version.package

      filename = "#{dir}/#{package.name}/#{version.number}/#{image.path}"
      FileUtils.mkdir_p File.dirname(filename)

      File.open(filename, "w") do |f|
        f.write image.raw_data
      end
    end
  end
end