Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/ping', to: 'application#ping'
  post '/tests/new', to: 'tests#new'
  get '/tests/next', to: 'tests#next'
end
