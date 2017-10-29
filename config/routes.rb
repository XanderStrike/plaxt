Rails.application.routes.draw do
  get 'home/index'

  get 'home/donate'

  post 'webhook(/:uid)', to: 'webhook#index'

  root 'home#index'
end
