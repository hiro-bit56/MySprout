class CreateFeedBacks < ActiveRecord::Migration[8.1]
  def change
    create_table :feed_backs do |t|
      t.references :user,     null: false, foreign_key: true
      t.integer :q1,          null: false
      t.text :q2
      t.text :q3

      t.timestamps
    end
  end
end
