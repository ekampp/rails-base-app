RailsBaseApp::Application.routes.draw do

  resources :projects, only: [ :show ]

  get 'login', to: "sessions#new"
  get 'logout', to: "sessions#destroy"
  get 'auth/:provider/callback', to: "sessions#create"

  root :to => 'home#welcome'
end
