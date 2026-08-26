class FeedBack < ApplicationRecord
  belongs_to :user

  enum :q1, [ :agree, :maybe, :disagree ]

  validates :user_id, presence: true
  validates :q1, presence: true
end
