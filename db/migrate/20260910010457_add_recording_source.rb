class AddRecordingSource < ActiveRecord::Migration[8.1]
  def change
    add_column :mood_records, :recording_source, :integer, null: false, default: 0
  end
end
