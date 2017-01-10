Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}

  get '/users/:id/portfolio', to: 'portfolio#show'
  get '/stocks/:id', to: 'stock#show'
  post '/users/:user_id/stocks/:id', to: 'stock#create'
end
