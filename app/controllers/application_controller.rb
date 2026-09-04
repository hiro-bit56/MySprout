class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
  
  add_flash_types :success, :alert
  before_action :require_login
  helper_method :footer_active?

  @test = controller_path

  private
  def not_authenticated
   redirect_to login_path, alert: t("defaults.login first"), status: :see_other
  end

  # ログイン済みでユーザー登録及びログインページにアクセスした場合の処理
  def if_logged_in
    if logged_in?
      redirect_to root_path, notice: t("defaults.if_logged_in")
    end
  end

  def mood_list
    # mood_levelのvery_good~very_badの配列を取得
    @mood_list = MoodRecord.mood_levels.keys
  end

  def footer_active?(section)
    case section
    when :home
      controller_path == "homes"
    when :record
      controller_path == "mood_records"
    when :link
      controller_path == "app_links"
    when :support
      controller_path.start_with?("support/")
    end
  end
end
