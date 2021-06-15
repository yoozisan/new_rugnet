class User < ApplicationRecord
  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
     # user.confirmed_at = Time.now  # Confirmable を使用している場合は必要
     # 例えば name を入力必須としているならば， user.name = "ゲスト" なども必要
    end
  end
  # enum role: { general: 1, admin: 99 }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :posts
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
