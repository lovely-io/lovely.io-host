require 'zlib'

module PackagesHelper
  def cdn_package_url(package, version=nil)
    super package, version, :host => "cdn.#{request.host_with_port}"
  end

  def gzipped_size(string)
    stream = Zlib::Deflate.new(Zlib::DEFAULT_COMPRESSION)
    result = stream.deflate(string, Zlib::FINISH)
    stream.close

    number_to_human_size(result.size)
  end
end