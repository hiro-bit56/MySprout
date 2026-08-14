class RatingGuideline < ApplicationRecord
  belongs_to :user

  # 気分のレベルとの対応
  enum :rating_level, [ :very_good, :good, :usually, :bad, :very_bad ]

  validates :guideline_text, presence: true
  validates :rating_level, uniqueness: { scope: :user_id }

end
