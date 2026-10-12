class Graph::MoodsController < ApplicationController
  def mood_month
    reference_on = params[:referenceOn].to_date
    reference_range = reference_on - 29.days..reference_on
    month_graph_data = (reference_range).index_with(nil)
    month_records = current_user.mood_records.where(record_on: reference_range)
    
    # 表示範囲
    first_date = reference_range.begin
    last_date  = reference_range.end
    formatted_date_range = "#{first_date.strftime('%Y/%m/%d')} 〜 #{last_date.strftime('%m/%d')}"

    # 記録と日付配列の紐づけ
    month_records.each do |record|
      month_graph_data[record.record_on] = record.read_attribute_before_type_cast(:mood_level)
    end
    render json: { 
      formatted_date_range: formatted_date_range,
      month_graph_data: month_graph_data
    }
  end
end
