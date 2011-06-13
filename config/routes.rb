Lovelyio::Application.routes.draw do

  resources :users
  resource  :profile, :controller => 'users'

  # authentication routes
  match '/login'                   => 'sessions#new',     :as => :login
  match '/logout'                  => 'sessions#destroy', :as => :logout
  match '/auth/:provider/callback' => 'sessions#create'   # omniauth callback
  match '/auth/failure'            => 'sessions#create'   # omniauth failures

  # static pages
  get '/:id' => "pages#show", :as => :page

  root :to => "pages#show", :id => 'index'

end
