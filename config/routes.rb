Quizmemanager::Application.routes.draw do
  
  post "mentions/update"

  match 'auth/:provider/callback' => 'accounts#update_omniauth'
  match "accounts/:id/scores" => "mentions#scores"
  match 'accounts/:id/stats' => 'accounts#stats'
  match 'accounts/:id/rts' => 'accounts#rts'

  resources :accounts
  resources :users
  resources :questions
  resources :posts
  resources :mentions

  root :to => 'accounts#index'
end
