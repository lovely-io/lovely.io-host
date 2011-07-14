class SessionsController < ApplicationController
  caches_page :new

  def new
  end

  def create
    if auth = request.env["omniauth.auth"]
      self.current_user = User.find_or_create_by_auth(auth)
      flash[:notice] = "Successfully logged in"
      redirect_back_or_to root_url
    else
      flash[:error] = "Failed to authenticate"
      render 'new'
    end
  end

  def destroy
    self.current_user = nil
    flash[:notice] = "Successfully logged out"
    redirect_back_or_to root_url
  end

end