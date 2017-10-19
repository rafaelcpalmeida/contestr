Rails.application.routes.draw do
  root 'welcome#index'
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  get '/dashboard' => 'dashboard#index'
  get '/projects/new' => 'projects#new'
  get '/projects/show' => 'projects#show'
  delete '/projects/show' => 'projects#delete'
  post '/projects/create' => 'projects#create'
end
