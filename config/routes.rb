Lovelyio::Application.routes.draw do
  resources :packages

  get '/packages/recent'  => 'packages#index', :order => 'recent',  :as => :recent_packages
  get '/packages/updated' => 'packages#index', :order => 'updated', :as => :updated_packages

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
