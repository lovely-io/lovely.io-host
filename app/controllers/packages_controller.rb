#
# NOTE: All packages are created and updated via the
#       `lovely` CLI tool which works via JSON format
#
class PackagesController < ApplicationController
  caches_page :index, :show, :demo

  # BUG: for some reason rails looses the `.html` extension
  #      when there is a version number at the end
  def self.page_cache_path(path, extension=nil)
    path = super(path, extension)
    path << extension if extension && !path.ends_with?(extension)
    path
  end

  before_filter :require_login, :only => [:create, :destroy]
  before_filter :find_package,  :only => [:show, :demo, :destroy]
  before_filter :find_version,  :only => [:show, :demo]

  def index
    @packages = (params[:user_id] ? User.find(params[:user_id]).packages : Package)
    @packages = @packages.includes(:owner)

    @packages = @packages.recent  if params[:order] == 'recent'
    @packages = @packages.updated if params[:order] == 'updated'
    @packages = @packages.like(params[:search]) unless params[:search].blank?

    @packages = @packages.order('name')

    respond_to do |format|
      format.html { @packages = @packages.paginate(:page => params[:page]) }
      format.atom { @packages = @packages.limit(10) }
      format.json { render :json => "[#{@packages.map(&:to_json).join(",")}]" }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render :json => @package.to_json }
    end
  end

  def demo
    raise NotFound if !@package.documents.demo
  end

  def create
    unless @package = find_existing_package
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

  def find_version
    @package.version = if params[:version]
      @package.versions.find_by_number(params[:version]) or raise(NotFound)
    else
      @package.versions.last
    end
  end

  def check_access
    if !admin? && @package.owner != current_user
      raise AccessDenied
    end
  end

  def find_existing_package
    if params[:package]
      @package_name = if params[:package][:manifest]
        @package_name = JSON.parse(params[:package][:manifest])['name']
      else
        params[:package][:name]
      end

      if @package_name && @package = Package.find_by_name(@package_name)
        check_access
        @package.attributes = params[:package]
        return @package
      end
    end

  rescue JSON::ParserError => e
    return nil
  end
end