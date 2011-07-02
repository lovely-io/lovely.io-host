#
# The static content controller
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class StaticController < ApplicationController

  def page
    file = "#{::Rails.root}/app/views/pages/#{params[:id]}.html.haml"
    if File.exists?(file)
      render :file => file
    else
      raise NotFound
    end
  end

end