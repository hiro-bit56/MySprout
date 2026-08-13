class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :mood_records, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

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
