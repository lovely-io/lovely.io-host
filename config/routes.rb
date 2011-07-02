Lovelyio::Application.routes.draw do
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

  # static pages
  get '/:id' => "pages#show", :as => :page

  root :to => "pages#show", :id => 'index'

end
