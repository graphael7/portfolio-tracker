Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}

  get '/users/:id/portfolio', to: 'portfolio#show'
end
