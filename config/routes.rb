Rails.application.routes.draw do
  root 'welcome#index'
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  get '/dashboard' => 'dashboard#index'
  get '/project/new' => 'project#new'
  get '/project/show' => 'project#show'
  delete '/project/show' => 'project#delete'
  post '/project/create' => 'project#create'
end
