class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy, foreign_key: 'tag_id'
  has_many :reviews, through: :taggings

  validates :name, uniqueness: true, presence:true, length:{maximum:50}
end
