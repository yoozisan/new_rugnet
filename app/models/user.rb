class User < ApplicationRecord
  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = 'guest_user'
    end
  end

  def self.guest_coach
    find_or_create_by!(email: 'guest_coach@example.com', coach: true) do |coach|
      coach.password = SecureRandom.urlsafe_base64
      coach.name = 'guest_coach'
    end
  end

  def self.guest_admin
    find_or_create_by!(email: 'guest_admin@example.com', admin: true) do |admin|
      admin.password = SecureRandom.urlsafe_base64
      admin.name = 'guest_admin'
    end
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  mount_uploader :image, ImageUploader
  # has_many :records, through: :student
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :students, dependent: :destroy
  has_many :active_relationships, foreign_key: 'follower_id', class_name: 'Relationship', dependent: :destroy
  has_many :passive_relationships, foreign_key: 'followed_id', class_name: 'Relationship', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validates :name, presence: true, length: { maximum: 15}

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  #   def clean_conversations
  #   Conversation.where("(sender_id = ?) OR (recipient_id = ?)", self.id, self.id).destroy_all
  # end
  #指定のユーザをフォローする
  def follow!(other_user)
    active_relationships.create!(followed_id: other_user.id)
  end
  #フォローしているかどうかを確認する
  def following?(other_user)
    active_relationships.find_by(followed_id: other_user.id)
  end
  #指定のユーザのフォローを解除する
  def unfollow!(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
end
