FutureGame::Application.routes.draw do

  # Maps the user account related paths
  match 'my_account', to: "users#edit", as: :my_account
  resources :users, path: "account", only: [ :update, :destroy, :edit ]

  # Maps login session paths
  resource :sessions, only: [ :new, :create, :destroy ]
  match 'login', to: "sessions#new", as: :login
  match 'logout', to: "sessions#destroy", as: :logout
  match 'auth/developer/callback', to: "sessions#create"

  root :to => 'home#index'

end
