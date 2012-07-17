Quizmemanager::Application.routes.draw do
  
  post "mentions/update"

  match 'auth/:provider/callback' => 'accounts#update_omniauth'
  match "accounts/:id/scores" => "mentions#scores"

  resources :accounts
  resources :users
  resources :questions
  resources :posts
  resources :mentions

  root :to => 'accounts#index'
end
