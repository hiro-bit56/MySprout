class AppLinksController < ApplicationController
  def show
    @has_token = current_user.api_token_digest.present? # userがトークンを発行しているか
  end

  def create
    token = current_user.generate_api_token # トークン生成（生のトークンが返される）
    has_token = current_user.api_token_digest.present? # userがトークンを発行しているか

    render json: { 
      token: token,
      has_token: has_token,
      message: "トークンはユーザーの証明書です。\n情報が漏れない様に注意してください。"
    }
  end
  
  def destroy
    # トークンを無効化
    current_user.update(api_token_digest: nil)
    has_token = current_user.api_token_digest.present? # userがトークンを発行しているか

    render json: { 
      has_token: has_token,
      message: "連携を解除しました"
    }
  end
end
