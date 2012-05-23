FutureGame::Application.routes.draw do
  # Maps the admin related stuff
  namespace :admin do
    # Administrate the users.
    # Since there is no need for the admins to view the users' profiles or
    # create users, we ommit these two from the resources.
    resources :users, except: [ :show, :create ]
  end

  # Maps the user account related paths
  # Users only needs three resources `edit`, `update` and `destroy`. Where the
  # `edit` resource is scoped under a pseudonym.
  match 'my_account', to: "users#edit", as: :my_account
  resources :users, only: [ :update, :destroy ]

  # Maps login session paths
  # The `sessions` resource is responsible for actually performing the
  # login/out, whie the matched paths are for ease of access and to catch third
  # party vendor logins.
  resource :sessions, only: [ :new, :create, :destroy ]
  match 'login', to: "sessions#new", as: :login
  match 'logout', to: "sessions#destroy", as: :logout
  match 'auth/:provider/callback', to: "sessions#create"

  # Catch all root path
  root :to => 'home#index'
end
