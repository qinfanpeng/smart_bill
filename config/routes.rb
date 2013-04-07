SmartBill::Application.routes.draw do
  root to: "bills#index"
  resources :bills
  resources :sessions, only: [:new, :create, :destroy]
  resources :users

  match '/signin', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy'
  match '/create_session', to: 'sessions#create'


end
