class Tag < ApplicationRecord
  has_many :tags, dependent: :destroy
  has_many :reviews, through: :taggings
  
  validates :name, presence:true, length:{maximum:50}
end
