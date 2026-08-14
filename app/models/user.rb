class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :mood_records, dependent: :destroy
  has_many :rating_guidelines, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  # デフォルトの評価の目安を作成  
  def create_default_guidelines
    RatingGuideline.create([
      { user: self, rating_level: :very_good, guideline_text: "なんでもできる気がする\n睡眠時間が短いが、とても活動的" },
      { user: self, rating_level: :good, guideline_text: "思考がポジティブ\nいつもより活発に動ける" },
      { user: self, rating_level: :usually, guideline_text: "安定した状態\nいつも通りに過ごせる" },
      { user: self, rating_level: :bad, guideline_text: "思考がネガティブ\n日常的な活動がつらい" },
      { user: self, rating_level: :very_bad, guideline_text: "何も感じない\n行動が起こせない" }
    ])
  end

  # ゲッターメソッド・セッターメソッドの作成
  attr_accessor :api_token

  # トークンの生成及びハッシュ化
  def generate_api_token
    self.api_token = SecureRandom.urlsafe_base64(32)
    self.api_token_digest = BCrypt::Password.create(api_token)
    save!
    api_token
  end
  
  # トークン認証
  def authenticate_api_token(token)
    return false unless api_token_digest
    BCrypt::Password.new(api_token_digest) == token
  end
  
  # トークンの再発行
  def regenerate_api_token
    generate_api_token
  end
end
