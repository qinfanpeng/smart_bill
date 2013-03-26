SmartBill::Application.routes.draw do
  resources :bills
  root to: "bills#index"

end
