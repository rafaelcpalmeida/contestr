Rails.application.routes.draw do
  root 'welcome#index'
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  get '/dashboard' => 'dashboard#index'
  get '/dashboard/new' => 'dashboard#new'
  get '/dashboard/show' => 'dashboard#show'
  delete '/dashboard/show' => 'dashboard#delete'
  post '/dashboard/create' => 'dashboard#create'
end
