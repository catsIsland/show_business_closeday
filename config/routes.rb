Rails.application.routes.draw do
  
  get 'settings', to: 'users#me'  
  
  post 'login', to: 'sessions#create'  
  
  delete 'logout', to: 'sessions#destroy'  

  get 'home', to: 'home#index'

  resources :users, only: %i[new create] 
  
  root 'home#index'
end
