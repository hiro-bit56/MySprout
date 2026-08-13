Rails.application.routes.draw do

  # Rails標準
  get "up" => "rails/health#show", as: :rails_health_check

  # ルート
  root "homes#index"

  # ユーザー登録＆ログイン
  resources :users, only: %i[new create]
  get 'login' => 'user_sessions#new', as: :login
  post 'login' => "user_sessions#create"
  post 'logout' => 'user_sessions#destroy', as: :logout

  # ホーム画面
  resources :homes, only: %i[index]

  # 記録画面
  resources :mood_records, only: %i[new create edit update destroy]

  # 情報画面
  resources :docs, only: %i[index] do
    resource :manual, only: %i[show]
  end

  # API連携画面
  resource :app_link, only: %i[show create destroy]

  # APIエンドポイント
  namespace :api do
    resources :mood_records, only: [:create]
  end
end
