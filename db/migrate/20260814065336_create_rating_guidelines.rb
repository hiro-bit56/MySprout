class CreateRatingGuidelines < ActiveRecord::Migration[8.1]
  def change
    create_table :rating_guidelines do |t|
      t.references :user,       null: false, foreign_key: true
      t.integer :rating_level,  null: false
      t.text :guideline_text,   null: false

      t.timestamps
    end
    add_index :rating_guidelines, [:user_id, :rating_level], unique: true
  end
end
