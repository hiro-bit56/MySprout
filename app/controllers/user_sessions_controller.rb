class UserSessionsController < ApplicationController

  skip_before_action :require_login, only: [:new, :create]
  
  def new; end
  
  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_back_or_to(homes_path, success: t('user_sessions.create.success'))
    else
      flash.now[:alert] = t('user_sessions.create.alert')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to login_path, success: t('user_sessions.destroy.success'), status: :see_other
  end
end
