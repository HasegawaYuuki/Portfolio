class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :reviews, dependent: :destroy

  has_one_attached :image

  def get_image(width,height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_limit: [width, height]).processed
  end

  has_many :active_relationships, class_name: "Relationship", foreign_key: "follow_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy

  has_many :followings, through: :active_relationships, source: :follower
  has_many :followers, through: :passive_relationships, source: :follow

  def follow(customer)
    active_relationships.create(follower_id: customer.id)
  end

  def unfollow(customer)
    active_relationships.find_by(follower_id: customer.id).destroy
  end

  def following?(customer)
    followings.include?(customer)
  end

end
