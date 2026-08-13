class AppLinksController < ApplicationController
  def show
    
  end

  def create
    # トークンを生成（平文のトークンが返される）
    token = current_user.generate_api_token
    
    # 一度だけ表示（この後は見られない）
    render json: { 
      api_token: token,
      message: 'このトークンは一度しか表示されません。安全な場所に保存してください。'
    }
  end
  
  def destroy
    # トークンを無効化
    current_user.update(api_token_digest: nil)
    render json: { message: 'トークンを無効化しました' }
  end
end
