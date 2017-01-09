Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}

  get '/users/:id/portfolio', to: 'portfolio#show'
  get '/stocks/:id', to: 'stock#show'
end
