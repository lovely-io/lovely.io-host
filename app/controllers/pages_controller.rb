#
# The static pages controller
#
# Copyright (C) 2011 Nikolay Nemshilov
#
class PagesController < ApplicationController

  def show
    if File.exists?("#{::Rails.root}/app/views/pages/#{params[:id]}.html.haml")
      render params[:id]
    else
      raise NotFound
    end
  end

end