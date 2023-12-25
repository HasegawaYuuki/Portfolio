class ReviewComment < ApplicationRecord

  belongs_to :customer
  belongs_to :review

  validates :comment, presence: true, length: { maximum: 300 }

end
