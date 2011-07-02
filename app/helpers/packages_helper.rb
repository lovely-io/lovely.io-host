module PackagesHelper
  def cdn_package_url(package, version=nil)
    if version
      "#{root_url}#{package.name}-#{version}.js"
    else
      "#{root_url}#{package.name}.js"
    end
  end
end