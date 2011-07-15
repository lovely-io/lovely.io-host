Lovelyio::Application.routes.draw do
  VERSION_RE = /\d+\.\d+\.\d+(-[a-z0-9]+)?/i

  get '/users/:user_id/packages(/search/:search)(/page/:page)' => 'packages#index', :as => :user_packages
  get '/packages(/search/:search)(/page/:page)'                => 'packages#index'

  resources :packages, :only => [:index, :show, :create, :destroy] do
    collection do
      get :recent,  :action => :index, :order => 'recent'
      get :updated, :action => :index, :order => 'updated'
    end
  end

  get '/packages/:id(/:version)'   => 'packages#show',  :as => :package, :constraints => {
    :version => VERSION_RE
  }

  resources :users
  resource  :profile, :controller => 'users' do
    get :token
  end

  resources :news

  # authentication routes
  match '/login'                   => 'sessions#new',     :as => :login
  match '/logout'                  => 'sessions#destroy', :as => :logout
  match '/auth/:provider/callback' => 'sessions#create'   # omniauth callback
  match '/auth/failure'            => 'sessions#create'   # omniauth failures

  # CDN urls
  get '/:id(-:version).js' => "static#script", :as => :cdn_package, :format => 'js', :constraints => {
    :version => VERSION_RE
  }

  # static pages
  get '/:id' => "static#page", :as => :page

  root :to => "static#page", :id => 'index'

end
