class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #いいね機能
  has_many :favorites, dependent: :destroy

  #コメント機能
  has_many :reviews, dependent: :destroy
  has_many :review_comments, dependent: :destroy

  #ゲストログイン機能
  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |customer|
      customer.password = SecureRandom.urlsafe_base64
      customer.name = "ゲストユーザー"
    end
  end

  #ActiveStorage
  has_one_attached :image

  def get_image(width,height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_limit: [width, height]).processed
  end

  #フォロー機能
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follow_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy

  has_many :followings, through: :active_relationships, source: :follower
  has_many :followers, through: :passive_relationships, source: :follow

    #フォローしたときの処理
  def follow(customer)
    active_relationships.create(follower_id: customer.id)
  end

    #フォローを外すときの処理
  def unfollow(customer)
    active_relationships.find_by(follower_id: customer.id).destroy
  end

    #フォローしていればtrueを返す
  def following?(customer)
    followings.include?(customer)
  end

  #ログイン時に退会済みのユーザーが同じアカウントでログイン出来ないようにする
  def active_for_authentication?
    super && (is_active == true)
  end

end
