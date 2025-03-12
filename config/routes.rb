Rails.application.routes.draw do
  get "password_resets/new"
  get "password_resets/create"
  get "password_resets/edit"
  get "password_resets/update"
  get "errors/not_found"
  get "errors/internal_server_error"
  get "errors/forbidden"
  # Root route
  root "home#index"
  
  # Authentication routes
  get "signup", to: "users#new"
  post "signup", to: "users#create"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  
  # Dashboard
  get "dashboard", to: "dashboard#index"
  
  # User profile
  get "profile", to: "users#edit"
  patch "profile", to: "users#update"

  #get 'test_email', to: 'users#test_email'
  
  # Resources
  resources :workouts
  resources :goals

  # For password resets
  resources :password_resets, only: [:new, :create, :edit, :update]

  # For error pages
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  match "/403", to: "errors#forbidden", via: :all
end