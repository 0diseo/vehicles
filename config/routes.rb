Rails.application.routes.draw do
  resources :vehicles
  resources :vehicle_models
  resources :vehicle_brands
  resource :users, only: [:create]
  post "/login", to: "users#login"
  get "/auto_login", to: "users#auto_login"
end
