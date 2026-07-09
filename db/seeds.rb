puts "テストデータを作成します"

# 日付オブジェクトの配列を作成
start_date = Date.new(2026, 5, 1)
end_date   = Date.new(2026, 7, 10)
date_array = (start_date..end_date).to_a

mood_list = ["best", "good", "usually", "bad", "worst"]

date_array.each do |date|
  record = MoodRecord.new
  record.user_id = 1
  record.mood_level = mood_list.sample
  record.record_on = date
  record.save!
end
  
puts "テストデータを #{MoodRecord.count} 件作成しました"
