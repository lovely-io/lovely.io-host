class ApplicationController < ActionController::Base
  protect_from_forgery

protected

########################################################################
# Common exception handlers
########################################################################

  class NotFound     < StandardError; end
  class AccessDenied < StandardError; end
  class RequireLogin < StandardError; end

  rescue_from NotFound,                     :with => :render_not_found
  rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
  rescue_from AccessDenied,                 :with => :render_access_denied
  rescue_from RequireLogin,                 :with => :render_require_login

  def render_not_found
    respond_to do |format|
      format.html { render "pages/404", :status => 404 }
      format.json { render :json => {:errors => {:server => "Not found"}}, :status => 404 }
    end

    false
  end

  def render_access_denied
    respond_to do |format|
      format.html { render "pages/422", :status => 422 }
      format.json { render :json => {:errors => {:server => "Access denied"}}, :status => 422 }
    end

    false
  end

  def render_require_login
    session[:return_to] = request.fullpath
    flash[:error] = "You must be logged in to access this page"

    respond_to do |format|
      format.html { render "sessions/new", :status => 422 }
      format.json { render :json => {:errors => {:server => "Authentication failed"}}, :status => 422 }
    end

    false
  end

  def redirect_back_or_to(url)
    redirect_to(session[:return_to] || url)
    session[:return_to] = nil
  end

######################################################################
# Authentication stuff
######################################################################

  helper_method :admin?, :logged_in?, :current_user

  def require_login
    raise RequireLogin unless logged_in?
  end

  def require_admin
    raise AccessDenied unless admin?
  end

  def admin?
    logged_in? && current_user.admin?
  end

  def logged_in?
    !current_user.nil?
  end

  def current_user
    @current_user ||= current_user_from_session || current_user_from_auth_token
  end

  def current_user=(user)
    if user
      session[:user_id] = user.id
      @current_user = user
    else
      @current_user = session[:user_id] = nil
    end
  end

  def current_user_from_session
    User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def current_user_from_auth_token
    User.find_by_auth_token(params[:auth_token]) if params[:auth_token]
  end
end
