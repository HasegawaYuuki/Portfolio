class Report < ApplicationRecord
  belongs_to :customer
  belongs_to :review
end
