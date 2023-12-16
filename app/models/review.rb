class Review < ApplicationRecord
  belongs_to :customer
  has_many :review_comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true
  validates :venue_name, presence: true
  validates :status, presence: true

  # ActiveStorage
  has_many_attached :review_images

  def get_review_image(width,height)
    unless review_images.attached?
     file_path = Rails.root.join('app/assets/images/no_image.jpg')
     review_images.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpeg')
    end
   review_images.(resize_to_limit: [width, height]).processed
  end

  # いいね機能
  has_many :favorites, dependent: :destroy

  def favorited_by?(customer)
   favorites.exists?(customer_id: customer.id)
  end

  # タグ機能
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  # タグ付けの新規投稿用メソッド
  def save_tags(tags)
    # タグが存在していれば、タグの名前を配列として全て取得
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # 現在取得したタグから送られてきたタグを除いてoldtagとする
    old_tags = current_tags - tags
    # 送信されてきたタグから現在存在するタグを除いたタグをnewとする
    new_tags = tags - current_tags

    # 古いタグを消す
    old_tags.each do |old|
      self.tags.delete　Tag.find_by(name: old)
    end

    # 新しいタグを保存
    new_tags.each do |new|
      tags = Tag.find_or_create_by(name: new)
      self.tags << tags
    end
  end

  # 検索機能のためのメソッド
  def self.looks(search, word)
    if search == "partial_match"
      @spoiler_reviews= Review.where("title LIKE?", "%#{word}%")
      @not_spoiler_reviews= Review.where("title LIKE?", "%#{word}%")
    end
  end

  enum status: { not_spoiler: 0, spoiler: 1, draft: 2 }
end
