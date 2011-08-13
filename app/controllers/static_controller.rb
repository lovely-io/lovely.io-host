#
# The static content controller
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class StaticController < ApplicationController
  caches_page :page

  before_filter :find_package_and_version, :only => [:script, :image]
  after_filter  :set_expiration_date, :only => [:script, :image]

  # static pages handler
  def page
    file = "#{::Rails.root}/app/views/pages/#{params[:id]}.html.haml"
    if File.exists?(file)
      render :file => file
    else
      raise NotFound
    end
  end

  # CDN mockery
  def script
    render :js => @version.build
  end

  # CDN images server
  def image
    @image = @version.images.find_by_path(params[:path]) or raise NotFound

    send_data @image.raw_data, {
      :type        => @image.content_type,
      :filename    => File.basename(@image.path),
      :disposition => 'inline'
    }
  end


protected

  def find_package_and_version
    @package = Package.find(params[:id])
    @version = (params[:version] ?
      @package.versions.find_by_number(params[:version]) :
      @package.versions.last) or raise NotFound
  end

  def set_expiration_date
    ttl = params[:version] ? 1.year : 1.day

    if item = @image || @version
      headers['Last-Modified'] = item.updated_at.rfc2822
      headers['Expires']       = (Time.now + ttl).rfc2822
      headers['Cache-Control'] = "max-age=#{ttl.to_i}, public"
      headers['ETag']          = "#{item.class.name}#{item.id}"
    end
  end

end