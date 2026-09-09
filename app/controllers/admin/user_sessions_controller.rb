class Admin::UserSessionsController < Admin::ApplicationController
  layout "admin"

  skip_before_action :require_login, only: [:new, :create]
  before_action :if_admin_logged_in, only: %i[new create]

  def new;  end

  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_back_or_to(admin_dashboards_path)
    else
      flash.now[:alert] = t('user_sessions.create.alert')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to admin_login_path, status: :see_other
  end

end