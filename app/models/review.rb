class Review < ApplicationRecord
  belongs_to :customer
  has_many :review_comments, dependent: :destroy

  #いいね機能
  has_many :favorites, dependent: :destroy

  def favorited_by?(customer)
   favorites.exists?(customer_id: customer.id)
  end

  #タグ機能
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  # タグ付けの新規投稿用メソッド
  def save_tags(sent_tags)
    # タグが存在していれば、タグの名前を配列として全て取得
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # 現在取得したタグから送られてきたタグを除いてoldtagとする
    old_tags = current_tags - sent_tags
    # 送信されてきたタグから現在存在するタグを除いたタグをnewとする
    new_tags = sent_tags - current_tags

    # 古いタグを消す
    old_tags.each do |old|
      self.tags.delete　Tag.find_by(name: old)
    end

    # 新しいタグを保存
    new_tags.each do |new|
      new_review_tag = Tag.find_or_create_by(name: new)
      self.tags << new_review_tag
    end
  end

  enum status: { not_spoiler: 0, spoiler: 1, draft: 2 }
end
