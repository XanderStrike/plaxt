Rails.application.routes.draw do
  get 'home/index'

  post 'webhook(/:uid)', to: 'webhook#index'

  root 'home#index'
end
