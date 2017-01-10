Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}

  get '/users/:id/portfolio', to: 'portfolio#show'
  get 'users/:id/portfolio/history', to: 'portfolio#history'
  
  get '/stocks/:id', to: 'stock#show'
  post '/users/:user_id/stocks/:id', to: 'stock#create'
end
