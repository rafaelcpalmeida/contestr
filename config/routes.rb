Rails.application.routes.draw do
  root 'welcome#index'
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  get '/dashboard' => 'dashboard#index'
  get '/dashboard/positions' => 'dashboard#positions'
  get '/dashboard/closed' => 'dashboard#closed'
  get '/projects/new' => 'projects#new'
  get '/projects/submissions/code' => 'projects#code'
  get '/project/submissions' => 'projects#submissions'
  get '/projects/show' => 'projects#show'
  get '/projects/details' => 'projects#details'
  delete '/projects/show' => 'projects#delete'
  post '/projects/create' => 'projects#create'
  get '/submissions/new' => 'submissions#new'
  post '/submission/upload' => 'submissions#upload'
  get '/projects/show/pdf' => 'projects#send_document'
  get '/projects/edit' => 'projects#edit'
  post '/projects/update' => 'projects#update'
  get '/projects/certificate' => 'projects#certificate', :format => 'pdf'
end
