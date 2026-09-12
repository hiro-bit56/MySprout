class MoodRecord < ApplicationRecord
  belongs_to :user

  enum :mood_level, [ :very_good, :good, :usually, :bad, :very_bad ]
  enum :recording_source, { home: 0, record: 10, api: 20 }

  validates :user_id, presence: true
  validates :record_on, presence: true
  validates :mood_level, presence: true
  validates :user_id, uniqueness: { scope: :record_on }
  validates :recording_source, presence: true
end
