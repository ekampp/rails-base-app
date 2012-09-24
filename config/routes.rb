EmilKampp::Application.routes.draw do

  get 'login', to: "sessions#new"
  get 'logout', to: "sessions#destroy"
  get 'auth/:provider/callback', to: "sessions#create"

  root :to => 'home#welcome'
end
