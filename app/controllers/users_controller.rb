class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  before_action :if_logged_in, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # デフォルトの評価の目安を作成
      @user.create_default_guidelines
      redirect_to login_path, success: t('users.create.success'), status: :see_other
    else
      flash.now[:alert] = t('users.create.alert')
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.expect(user: [:name, :email, :password, :password_confirmation])
  end
end
