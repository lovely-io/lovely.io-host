class UsersController < ApplicationController
  before_filter :require_login, :except => [:show, :new, :create, :destroy]
  before_filter :require_admin, :only   => :index
  before_filter :find_user,     :except => :index
  before_filter :check_access,  :only   => [:edit, :update]

  def index
    @users = User.order('name')
  end

  def show
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = "Profile was successfully updated"
      redirect_to profile_path
    else
      render 'edit'
    end
  end

  def token
    @token = @user.new_auth_token! if params[:create]
  end

  # blocking the rest of the REST
  def new()     raise NotFound end
  def create()  raise NotFound end
  def destroy() raise NotFound end

protected

  def find_user
    @user = if request.fullpath.starts_with?(profile_path)
      raise AccessDenied if !logged_in?
      current_user
    else
      User.find(params[:id])
    end
  end

  def check_access
    raise AccessDenied if !admin? and @user != current_user
  end
end