class CreateMoodRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :mood_records do |t|
      t.references :user,     null: false, foreign_key: true
      t.date :record_on,      null: false
      t.integer :mood_level,  null: false

      t.timestamps
    end

    add_index :mood_records, [:user_id, :record_on], unique: true
  end
end
