Rails.application.routes.draw do
  root 'home#index'

  get 'settings', to: 'users#settings'
  get 'home', to: 'home#index'

  post 'login', to: 'sessions#create'
  post 'close_days', to: 'close_days#data'
  post 'save_weekly_data', to: 'close_days#weekly_data'
  post 'save_other_close_days', to: 'close_days#other_close_days'

  delete 'logout', to: 'sessions#destroy'

  resources :users, only: %i[new create]
  
end
