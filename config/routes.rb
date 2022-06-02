Rails.application.routes.draw do
  root 'home#index'

  get 'settings', to: 'users#settings'
  get 'home', to: 'home#index'

  post 'login', to: 'sessions#create'
  post 'close_days', to: 'close_days#data'

  delete 'logout', to: 'sessions#destroy'

  resources :users, only: %i[new create]
  
end
