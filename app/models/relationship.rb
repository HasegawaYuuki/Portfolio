class Relationship < ApplicationRecord
  belongs_to :follow, class_name: "Customer"
  belongs_to :follower, class_name: "Customer"
end
