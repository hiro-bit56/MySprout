class Admin::Dashboard
  def initialize
    @users = User.all
    @mood_records = MoodRecord.all
  end

  def user_count
    @week_records = @mood_records.where(created_at: 1.week.ago..Time.current)
    @week_users_id = @week_records.select(:user_id).distinct
    {
      total_users_count: @users.count,
      week_users_count: @week_users_id.count
    }
  end

  def resume_record
    # 気力がないときに記録を続けられるかの計測(現在は、気分で代用)
    all_cases = 0
    tomorrow_record = 0
    week_record = 0
    month_record = 0
    no_record = 0  # 1カ月以内に再記録されなかった場合は「記録なし」として計上
    low_mood_records = @mood_records.where(mood_level: 3..4)
    low_mood_records.each do |record|
      all_cases += 1
      user_records = MoodRecord.where(user_id: record.user_id).order(:record_on)
      after_record = user_records.find_by("record_on > ?", record.record_on)&.record_on
      if after_record.nil?
        no_record += 1 # 記録なしの場合のカウント
      elsif after_record == record.record_on.tomorrow
        tomorrow_record += 1
      elsif after_record <= record.record_on + 1.week
        week_record += 1
      elsif after_record <= record.record_on.next_month
        month_record += 1
      else
        no_record += 1 # 記録が1カ月以上空いた場合のカウント
      end
    end
    tomorrow_ratio = all_cases.zero? ? 0 : (tomorrow_record.to_f/all_cases)*100
    week_ratio = all_cases.zero? ? 0 : (week_record.to_f/all_cases)*100
    month_ratio = all_cases.zero? ? 0 : (month_record.to_f/all_cases)*100
    no_ratio = all_cases.zero? ? 0 : (no_record.to_f/all_cases)*100
    {
      all_cases: all_cases,
      tomorrow_ratio: tomorrow_ratio.round(1),
      week_ratio: week_ratio.round(1),
      month_ratio: month_ratio.round(1),
      no_ratio: no_ratio.round(1)
    }
  end

  def recording_route
    home = @mood_records.where(recording_source: "home").count
    record = @mood_records.where(recording_source: "record").count
    api = @mood_records.where(recording_source: "api").count
    all_cases = home + record + api
    home_ratio = all_cases.zero? ? 0 : (home.to_f/all_cases)*100
    record_ratio = all_cases.zero? ? 0 : (record.to_f/all_cases)*100
    api_ratio = all_cases.zero? ? 0 : (api.to_f/all_cases)*100
    {
      all_cases: all_cases,
      home_ratio: home_ratio.round(1),
      record_ratio: record_ratio.round(1),
      api_ratio: api_ratio.round(1)
    }
  end

  def api_used_users
    all_api_record = @mood_records.where(recording_source: "api")
    all_user_id = all_api_record.select(:user_id).distinct
    week_api_record = all_api_record.where(record_on: 1.week.ago..Date.current)
    week_user_id = week_api_record.select(:user_id).distinct
    month_api_record = all_api_record.where(record_on: 1.month.ago..Date.current)
    month_user_id = month_api_record.select(:user_id).distinct
    {
      all: all_user_id.count,
      week: week_user_id.count,
      month: month_user_id.count
    }
  end
end