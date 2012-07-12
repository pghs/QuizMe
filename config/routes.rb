Quizmemanager::Application.routes.draw do
  
  get "mentions/update"

  match 'auth/:provider/callback' => 'accounts#update_omniauth'

  resources :accounts
  resources :users
  resources :questions
  resources :posts
  resources :mentions

  root :to => 'accounts#index'
end
