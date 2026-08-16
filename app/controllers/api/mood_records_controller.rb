class Api::MoodRecordsController < ApplicationController
  # HTTP Request Shortcutsを通すための設定
  skip_before_action :require_login, only: [:create]
  skip_before_action :verify_authenticity_token  # CSRFチェックを無効化
  before_action :authenticate_with_api_token  # トークン認証に切り替え

  def create
    mood = @current_user.mood_records.build(mood_params)
    today = Date.current
    mood.record_on = today
    if mood.save
      render json: { message: "記録しました" }, status: :created
    else
      render json: { errors: "失敗しました" }, status: :unprocessable_entity
    end
  end

  private

  def authenticate_with_api_token
    # Authorization ヘッダーからトークンを取得
    token = request.headers['Authorization']&.gsub(/^Bearer /, '')
  
    unless token
      render json: { error: 'トークンが必要です' }, status: :unauthorized
      return
    end
  
    # すべてのユーザーを検索してトークンが一致するか確認
    @current_user = User.find { |user| user.authenticate_api_token(token) }
  
    unless @current_user
      render json: { error: '無効なトークンです' }, status: :unauthorized
    end
  end

  def mood_params
    params.permit(:mood_level)
  end
end
