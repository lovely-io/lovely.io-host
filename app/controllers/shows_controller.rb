class ShowsController < ApplicationController
  caches_page :index, :show

  before_filter :require_admin, :except => [:index, :show]
  before_filter :find_show, :only => [:show, :edit, :update, :destroy]

  def index
    @shows = Show.latest.paginate(:page => params[:page])
  end

  def show
  end

  def new
    @show = Show.new
  end

  def create
    @show = Show.new(params[:show])
    @show.author = current_user

    if @show.save
      redirect_to @show
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @show.update_attributes(params[:show])
      redirect_to @show
    else
      render 'edit'
    end
  end

  def destroy
    @show.destroy
    redirect_to shows_path
  end

protected

  def find_show
    @show = Show.find(params[:id])
  end
end
