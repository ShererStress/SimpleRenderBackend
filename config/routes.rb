Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # User routes
  get '/users', to: 'users#index'
  get '/users/:id', to: 'users#show'
  post "users/logIn", to: "users#authenticate"
  post '/users', to: 'users#create'

end
