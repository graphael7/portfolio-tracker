Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}

  get '/users/:id/portfolio', to: 'portfolio#show'

  get 'users/:id/portfolio/history', to: 'portfolio#history'
end
