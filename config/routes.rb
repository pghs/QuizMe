Quizmemanager::Application.routes.draw do
  get "feeds/index"

  match "feeds/:id/more/:last_post_id" => "feeds#more"
  match "feeds/:id" => "feeds#show"

  post "mentions/update"

  match 'auth/:provider/callback' => 'sessions#create'
  match "/signout" => "sessions#destroy", :as => :signout

  match 'questions/import_data_from_qmm' => 'questions#import_data_from_qmm'

  resources :accounts
  resources :users
  resources :questions
  resources :posts
  resources :mentions

  root :to => 'feeds#index'
end
