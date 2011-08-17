Lovelyio::Application.routes.draw do
  VERSION_RE = /\d+\.\d+\.\d+(-[a-z0-9]+)?/i

  get '/users/:user_id/packages(/search/:search)(/page/:page)' => 'packages#index', :as => :user_packages
  get '/tags/:tag/(/search/:search)(/page/:page)'              => 'packages#index', :as => :tagged_packages
  get '/packages(/search/:search)(/page/:page)'                => 'packages#index'


  resources :packages, :only => [:index, :show, :create, :destroy] do
    collection do
      get :recent,  :action => :index, :order => 'recent'
      get :updated, :action => :index, :order => 'updated'
    end
  end

  get '/packages/:id/changelog' => 'packages#changelog', :as => :package_changelog

  get '/packages/:id(/:version)/demo' => 'packages#demo', :as => :package_demo, :constraints => {
    :version => VERSION_RE
  }

  get '/packages/:id(/:version)'   => 'packages#show',  :as => :package, :constraints => {
    :version => VERSION_RE
  }

  resources :users
  resource  :profile, :controller => 'users' do
    get :token
  end

  get '/news(/page/:page)' => 'news#index'
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
  get '/:id(/:version)/:path' => "static#image", :as => :cdn_image, :constraints => {
    :version => VERSION_RE, :path => /[\w\d\/\-\_\._]+\.(gif|png|jpg|jpeg|svg|swf)/i
  }

  # static pages
  get '/:id' => "static#page", :as => :page

  root :to => "static#page", :id => 'index'

end
