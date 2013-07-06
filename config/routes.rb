SmartBill::Application.routes.draw do
    resources :goods

  root to: "application#welcome"

  resources :bills do
    collection do
      get :settle
      get :my
      get :about_me
    end
  end
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

  resources :groups do
    member do
      get :new_member_to
      post :add_member_to
      get :members_of
      delete :remove_member_of
      get :members_select_of
      get :bills_of
      get :settle
    end
    collection do
      get :my
    end
  end

  match '/signin', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy'
  match '/goods_names', to: 'good_names#names'
  match '/forget_password', to: 'users#forget_password'
  match '/get_password', to: 'users#get_password'
end
