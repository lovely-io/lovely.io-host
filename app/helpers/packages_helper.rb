module PackagesHelper
  def cdn_package_url(package, version=nil)
    super package, version, :host => "cdn.#{request.host_with_port}"
  end
end