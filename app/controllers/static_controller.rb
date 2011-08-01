#
# The static content controller
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class StaticController < ApplicationController
  caches_page :page

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
    @package = Package.find(params[:id])
    @version = (params[:version] ?
      @package.versions.find_by_number(params[:version]) :
      @package.versions.last) or raise NotFound

    render :js => @version.build

    expires_in params[:version] ? 1.year : 1.day, :public => true
  end

end