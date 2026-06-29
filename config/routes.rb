Rails.application.routes.draw do

  # Rails標準
  get "up" => "rails/health#show", as: :rails_health_check

  # ルート
  root "homes#index"

  # 実装確認用のルート
  # root "user_sessions#new"

  # ユーザー関係
  resources :users, only: %i[new create]
  get 'login' => 'user_sessions#new', as: :login
  post 'login' => "user_sessions#create"
  post 'logout' => 'user_sessions#destroy', as: :logout

  # 機能関係
  resources :homes, only: %i[index]
  resources :mood_records
end
