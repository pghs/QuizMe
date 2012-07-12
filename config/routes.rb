Quizmemanager::Application.routes.draw do
  
  match 'auth/:provider/callback' => 'accounts#update_omniauth'

  resources :accounts
  resources :users
  resources :questions
  resources :posts
  resources :mentions

  root :to => 'accounts#index'
end
