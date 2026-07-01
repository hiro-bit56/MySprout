class MoodRecord < ApplicationRecord
  belongs_to :user

  enum :mood_level, [ :best, :good, :usually, :bad, :worst ]

  validates :user_id, presence: true
  validates :record_on, presence: true
  validates :mood_level, presence: true
  validates :user_id, uniqueness: { scope: :record_on }
end
