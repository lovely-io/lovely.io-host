#
# The static content controller
#
# Copyright (C) 2011 Nikolay Nemshilov
#
require 'zlib'
class StaticController < ApplicationController
  caches_page :page

  before_filter :find_package_and_version, :only => [:script, :image]
  after_filter  :set_expiration_date,      :only => [:script, :image, :sha]

  # static pages handler
  def page
    file = "#{::Rails.root}/app/views/pages/#{params[:id]}.html.haml"
    if File.exists?(file)
      render "pages/#{params[:id]}"
    else
      raise NotFound
    end
  end

  # CDN mockery
  def script
    if recently_modified?(@version)
      # force gzipping the scripts coz CloudFront can't do that for us
      headers['Content-Encoding'] = 'gzip'

      io   = StringIO.new
      gzip = Zlib::GzipWriter.new(io)
      gzip << @version.build
      gzip.close

      render :js => io.string
    end
  end

  # CDN images server
  def image
    @image = @version.images.find_by_path(params[:path]) or raise NotFound
    send_image
  end

  # CDN assets serving by a SHA signature
  def sha
    @image = Image.find_by_sha(params[:sha]) or raise NotFound
    params[:version] = 'dummy' # force 1 year expiration time
    headers['Access-Control-Allow-Origin'] = "*"
    send_image
  end


protected

  def find_package_and_version
    @package = Package.find(params[:id])
    @version = (params[:version] ?
      @package.versions.find_by_number(params[:version]) :
      @package.versions.last) or raise NotFound
  end

  def send_image
    if recently_modified?(@image)
      send_data @image.raw_data, {
        :type        => @image.content_type,
        :filename    => File.basename(@image.path),
        :disposition => 'inline'
      }
    end
  end

  def recently_modified?(item)
    stale?(:etag => etag(item), :last_modified => item.updated_at.utc, :public => true)
  end

  def set_expiration_date
    ttl = params[:version] ? 1.year : 1.day

    if item = (@image || @version)
      headers['Last-Modified'] = item.updated_at.utc.httpdate
      headers['Expires']       = (Time.now + ttl).utc.httpdate
      headers['Cache-Control'] = "max-age=#{ttl.to_i}, public"
      headers['ETag']          = etag(item)
    end
  end

  def etag(item)
    Digest::MD5.hexdigest(ActiveSupport::Cache.expand_cache_key(item))
  end

end