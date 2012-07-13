Quizmemanager::Application.routes.draw do
  get "feeds/index"

  match "feeds/:id" => "feeds#show"

  post "mentions/update"

  match 'auth/:provider/callback' => 'sessions#create'

  resources :accounts
  resources :users
  resources :questions
  resources :posts
  resources :mentions

  root :to => 'feeds#index'
end
