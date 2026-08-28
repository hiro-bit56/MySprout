class AppLinksController < ApplicationController
  def show
    
  end

  def create
    # トークンを生成（平文のトークンが返される）
    token = current_user.generate_api_token
    
    # 一度だけ表示（この後は見られない）
    render json: { 
      api_token: token,
      message: "トークンはユーザーの証明書です。\n情報が漏れない様に注意してください。"
    }
  end
  
  def destroy
    # トークンを無効化
    current_user.update(api_token_digest: nil)
    render json: { message: 'トークンを無効化しました' }
  end
end
