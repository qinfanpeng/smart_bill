SmartBill::Application.routes.draw do
    resources :goods

  root to: "bills#index"
  resources :bills
  resources :sessions, only: [:new, :create, :destroy]
  resources :users

  match '/signin', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy'
  match 'my_bills', to: 'bills#my_bills'
  match '/about_me', to: 'bills#about_me'
  match '/good_names', to: 'good_names#names'

end
