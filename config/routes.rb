SmartBill::Application.routes.draw do
    resources :goods

  root to: "bills#index"
  resources :bills
  resources :sessions, only: [:new, :create, :destroy]
  resources :users do
    member do
      get 'edit_email'
      post 'update_email'
      get 'edit_password'
      post 'update_password'
    end
  end
  resources :good_names

  match '/signin', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy'
  match 'my_bills', to: 'bills#my_bills'
  match '/about_me', to: 'bills#about_me'
  match '/goods_names', to: 'good_names#names'
 # match '/edit_email', to: 'users#edit_email'
 # match '/update_email', to: 'users#update_email'
  match 'forget_password', to: 'users#forget_password'
end
