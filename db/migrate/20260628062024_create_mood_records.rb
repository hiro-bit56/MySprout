class CreateMoodRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :mood_records do |t|
      t.references :user,   null: false, foreign_key: true
      t.date :record_date,  null: false
      t.integer :mood,      null: false

      t.timestamps
    end

    add_index :mood_records, [:user_id, :record_date], unique: true
    add_index :mood_records, [:record_date, :mood], unique: true
  end
end
