class MoodRecordsController < ApplicationController
  def new
    @record = MoodRecord.new
    mood_list
  end

  def create
    @record = current_user.mood_records.build(record_params)
    if @record.save
      redirect_to mood_records_path, success: t('mood_records.create.success')
    else
      flash.now[:alert] = t('mood_records.create.alert')
      mood_list
      render :new, status: :unprocessable_entity
    end
  end

  private

  def record_params
    params.require(:mood_record).permit(:record_on, :mood_level)
  end

  def mood_list
    # mood_levelのbest~worstのハッシュ値を取得(「best: 0」の形で取得)
    @mood_list = MoodRecord.mood_levels
  end
end
