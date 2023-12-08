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
  
  def save_tags(tag_list)
    #タグが存在していれば、タグの名前を配列として全て取得
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    #現在取得したタグから送られてきたタグを除いてoldtagとする
    old_tags = current_tags - tags
    #送信されてきたタグから現在存在するタグを除いたタグをnewとする
    new_tags = tags - current_tags
    #古いタグを消す
    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name:old_name)
    end
    #新しいタグを保存
    new_tags.each do |new_name|
      tag = Tag.find_or_create_by(name:new_name)
      self.tags << tag
    end
  end
end
