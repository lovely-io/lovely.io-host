class ApplicationController < ActionController::Base
  protect_from_forgery

protected

  class NotFound < StandardError;     end
  class AccessDenied < StandardError; end

  rescue_from NotFound,                        :with => :render_not_found
  rescue_from ActiveRecord::RecordNotFound,    :with => :render_not_found
  rescue_from AccessDenied,                    :with => :render_access_denied

  def render_not_found
    render "pages/404", :status => 404
    false
  end

  def render_access_denied
    render "pages/422", :status => 422
    false
  end
end
