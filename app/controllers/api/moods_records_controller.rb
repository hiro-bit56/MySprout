module Api
  class MoodRecordsController < ApplicationController
    # HTTP Request Shortcutsを通すための設定
    skip_before_action :require_login, only: [:create]
    skip_before_action :verify_authenticity_token  # CSRFチェックを無効化
    before_action :authenticate_with_token  # トークン認証に切り替え

    def create
      @mood_record = current_user.mood_records.create!(mood_params)
      render json: { status: 'success', mood: @mood_record }, status: :created
    end

    private

    def authenticate_with_token
      token = request.headers['Authorization']&.split(' ')&.last
      @current_user = User.find_by(api_token: token)
      
      render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
    end

    def mood_params
      params.require(:mood_records).permit(:record_on, :mood_level)
    end
  end
end