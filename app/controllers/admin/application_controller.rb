class Admin::ApplicationController < ActionController::Base
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # 標準設定
  allow_browser versions: :modern # 古いブラウザからのアクセスを制限
  stale_when_importmap_changes  # 常に最新のimportmapが読み込まれるようになる
  
  add_flash_types :success, :alert
  before_action :require_login

  private
  # ログイン済みでユーザー登録及びログインページにアクセスした場合の処理
  def if_admin_logged_in
    if logged_in?
      redirect_to admin_dashboards_path
    end
  end

  def user_not_authorized
    redirect_to root_path, alert: t("defaults.admin.rejection")
  end
end