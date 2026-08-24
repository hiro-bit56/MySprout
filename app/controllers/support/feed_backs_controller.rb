class Support::FeedBacksController < ApplicationController
  
  def new
    @feed_back = FeedBack.new
    q1_choices
  end

  def create
    @feed_back = current_user.feed_backs.build(feed_back_params)
    if @feed_back.save
      redirect_to homes_path, success: t('feed_backs.create.success')
    else
      flash.now[:alert] = t('feed_backs.create.alert')
      q1_choices
      render :new, status: :unprocessable_entity
    end
  end

  private

  def q1_choices
    # q1のyes~noの配列を取得
    @q1_choices = FeedBack.q1s.keys
  end

  def feed_back_params
    params.require(:feed_back).permit(:q1, :q2, :q3)
  end

end