class NewsController < ApplicationController
  before_filter :require_admin, :except => [:index, :show]
  before_filter :find_news, :only => [:show, :edit, :update, :destroy]

  def index
    @news = News.latest.paginate(:page => params[:page])
  end

  def show
  end

  def new
    @news = News.new
  end

  def create
    @news = News.new(params[:news])
    @news.author = current_user

    if @news.save
      redirect_to @news
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @news.update_attributes(params[:news])
      redirect_to @news
    else
      render 'edit'
    end
  end

  def destroy
    @news.destroy
    redirect_to news_index_path
  end

protected

  def find_news
    @news = News.find(params[:id])
  end

end