Quizmemanager::Application.routes.draw do
  
  get "feeds/index"

  get "feeds/show"

  post "mentions/update"

  match 'auth/:provider/callback' => 'accounts#update_omniauth'

  resources :accounts
  resources :users
  resources :questions
  resources :posts
  resources :mentions

  root :to => 'feeds#index'
end
