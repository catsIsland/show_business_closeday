Rails.application.routes.draw do
  root 'home#index'

  get 'settings', to: 'users#settings'
  get 'home', to: 'home#index'
  get 'delete_user', to: 'users#delete_user'

  post 'login', to: 'sessions#create'
  post 'close_days', to: 'close_days#data'
  post 'save_setting_detail', to: 'close_days#setting_detail'
  post 'save_other_close_days', to: 'close_days#other_close_days'

  delete 'logout', to: 'sessions#destroy'

  resources :users, only: %i[new create]
  
end
