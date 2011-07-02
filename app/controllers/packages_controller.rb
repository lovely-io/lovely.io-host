#
# NOTE: All packages are created and updated via the
#       `lovely` CLI tool which works via JSON format
#
class PackagesController < ApplicationController
  before_filter :require_login, :only => [:create, :destroy]
  before_filter :find_package,  :only => [:show,   :destroy]

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

  def new()    raise NotFound end
  def edit()   raise NotFound end
  def update() raise NotFound end

  def create
    if params[:package] && @package = Package.find_by_name(params[:package][:name])
      check_access
      @package.attributes = params[:package]
    else
      @package = Package.new(params[:package])
      @package.owner = current_user
    end

    render :json => @package.save ?
      {:url => package_url(@package)} :
      {:errors => @package.errors}
  end

  def destroy
    check_access

    render :json => if @version = @package.versions.find_by_number(params[:version])
      @version.destroy
      @package.destroy if @package.versions.count == 0

      {:url => packages_url}
    else
      {:errors => {:server => "can't find the version"}}
    end
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