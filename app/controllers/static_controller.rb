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
    filename = if params[:version]
      "#{ASSETS_DIR}/#{params[:id]}-#{params[:version]}.js"
    elsif params[:id]
      files = Dir["#{ASSETS_DIR}/#{params[:id]}-*.js"].map do |name|
        name = File.basename(name)
        name =~ /#{Regexp.escape(params[:id])}-\d+\.\d+\.\d+(-[a-zA-Z0-9]+)?\.js/ ? name : nil
      end.compact

      "#{ASSETS_DIR}/#{files.compact.sort.last}"
    else
      nil
    end

    render :js => File.read(filename) rescue raise(NotFound)

    expires_in params[:version] ? 1.year : 1.day, :public => true
  end

end