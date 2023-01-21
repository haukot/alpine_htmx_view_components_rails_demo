Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # TODO: how to move this to a gem?
  post '/components/:component', to: 'components#component'
end
