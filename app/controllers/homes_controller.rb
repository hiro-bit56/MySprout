class HomesController < ApplicationController
  def index
    # ここから、当日の記録機能用
    @mood_record = MoodRecord.new
    mood_list
    @today_mood = current_user.mood_records.find_by(record_on: Date.current)

    # ここから、記録の閲覧機能用
    # 検索範囲の設定
    @year = year_params || Date.current.year
    @month = month_params || Date.current.month
    start_date = Date.new(@year, @month, 1)
    end_date = start_date.end_of_month

    # 気分、睡眠、エネルギーの1か月分のデータを取得
    @month_mood_record = current_user.mood_records.where(record_on: start_date..end_date).order(:record_on)

    # 追加したら睡眠状況やエネルギーも気分と同様に取得する

    # データの結合(記録項目を増やしたらここで結合する)
    @month_records = @month_mood_record
  end

  private

  def year_params
    # 空のパラメータを許可するためにpermitのみを使用
    tmp = params.permit(date: [:year]).dig(:date, :year)
    # データが空の場合はnilが欲しいため三項演算子使用(.to_iはnilだと0を返す)
    tmp.nil? ? nil:tmp.to_i
  end

  def month_params
    tmp = params.permit(date: [:month]).dig(:date, :month)
    tmp.nil? ? nil:tmp.to_i
  end
end
