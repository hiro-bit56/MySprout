class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  add_flash_types :success, :alert

  before_action :require_login

  private
  def not_authenticated
   redirect_to login_path, alert: "Please login first", status: :see_other
  end
end
