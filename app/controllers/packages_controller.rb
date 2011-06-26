#
# NOTE: All packages are created and updated via the
#       `lovely` CLI tool which works via JSON format
#
class PackagesController < ApplicationController
  before_filter :require_login, :only => [:create, :update, :destroy]
  before_filter :find_package,  :only => [:show, :update, :destroy]
  before_filter :check_access,  :only => [:update, :destroy]

  def index
    @packages = (params[:user_id] ? User.find(params[:user_id]).packages : Package)
    @packages = @packages.order('name').includes(:owner)

    @packages = @packages.recent  if params[:order] = 'recent'
    @packages = @packages.updated if params[:order] = 'updated'
    @packages = @packages.like(params[:search]) unless params[:search].blank?

    @packages = @packages.paginate(:page => params[:page], :per_page => params[:per_page] || 10)

    respond_to do |format|
      format.html
      format.json { render :json => @packages }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render :json => @package }
    end
  end

  def new()  raise NotFound end
  def edit() raise NotFound end

  def create
    @package = Package.new(params[:package])
    @package.owner = current_user

    if @package.save
      render :json => {:url => package_url(@package)}
    else
      render :json => {:errors => @package.errors}
    end
  end

  def update
    if @package.update_attributes(params[:package])
      render :json => {:url => package_url(@package)}
    else
      render :json => {:errors => @package.errors}
    end
  end

  def destroy
    @package.destroy

    render :json => {:url => packages_url}
  end

protected

  def find_package
    @package = Package.find(params[:id])
  end

  def check_access
    if !admin? && @package.owner != current_user
      raise AccessDenied
    end
  end

end