Rails.application.routes.draw do
  get 'sessions/new'
  root 'static_pages#home'
  
  get '/help', :to => 'static_pages#help'
  get '/about', :to => 'static_pages#about'
  get '/contacts', :to => 'static_pages#contacts'
  get '/signup', :to => 'users#new'
  post '/signup',	to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post    '/login',   to: 'sessions#create'
  delete    '/logout',   to: 'sessions#destroy'

  resources :microposts, only: [:create, :destroy]
  resources :users do
    member do
      get :following, :followers
    end 
  end
  resources :relationships, only: [:create, :destroy]

end
