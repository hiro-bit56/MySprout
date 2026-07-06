class MoodRecordsController < ApplicationController
  def new
    @mood_record = MoodRecord.new
    mood_list
  end

  def create
    @mood_record = current_user.mood_records.build(record_params)
    if @mood_record.save
      redirect_to homes_path, success: t('mood_records.create.success')
    else
      flash.now[:alert] = t('mood_records.create.alert')
      mood_list
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @mood_record = current_user.mood_records.find(params[:id])
    mood_list
  end

  def update
    @mood_record = current_user.mood_records.find(params[:id])
    if @mood_record.update(record_params)
      redirect_to homes_path, success: t('mood_records.update.success')
    else
      flash.now[:alert] = t('mood_records.update.alert')
      mood_list
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @mood_record = current_user.mood_records.find(params[:id])
    @mood_record.destroy!
    redirect_to homes_path, success: t('mood_records.destroy.success'), status: :see_other
  end

  private
  def record_params
    params.require(:mood_record).permit(:record_on, :mood_level)
  end
end
