class Favorite < ApplicationRecord
    
  belongs_to :customer
  belongs_to :review
  
  validates :customer_id, uniqueness: {scope: :review_id}
    
end
