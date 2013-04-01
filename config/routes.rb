SmartBill::Application.routes.draw do
  root to: "bills#index"
  resources :bills
  resources :sessions, only: [:new, :create, :destroy]

  match '/signin', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy'



end
