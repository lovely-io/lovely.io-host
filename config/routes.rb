Lovelyio::Application.routes.draw do
  VERSION_RE = /\d+\.\d+\.\d+(-[a-z0-9]+)?/i

  get '/packages(/page/:page)'     => 'packages#index'
  get '/packages/search(/:search)' => 'packages#index'
  get '/packages/:id(/:version)'   => 'packages#show',  :as => :package, :constraints => {
    :version => VERSION_RE
  }

  resources :packages, :only => [:index, :show, :create, :destroy] do
    collection do
      get :recent,  :action => :index, :order => 'recent'
      get :updated, :action => :index, :order => 'updated'
    end
  end

  resources :users
  resource  :profile, :controller => 'users' do
    get :token
  end

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
