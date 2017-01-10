Rails.application.routes.draw do
  devise_for :users

  get '/users/:id/portfolio', to: 'portfolio#show'
  get 'users/:id/portfolio/history', to: 'portfolio#history'

  get '/stocks/:id', to: 'stock#show'
end
