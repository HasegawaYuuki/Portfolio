class ReviewComment < ApplicationRecord

  belongs_to :user
  belongs_to :review

  #parentは返信対象となるコメント
  belongs_to :parent, class_name: "ReviewComment", optional: true
  #repliesは返信されたコメント
  has_many :replies, class_name: "ReviewComment", foreign_key: :parent_id, dependent: :destroy

  validates :comment, presence: true, length: { maximum: 300 }

end
