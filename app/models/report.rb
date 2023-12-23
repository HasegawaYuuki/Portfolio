class Report < ApplicationRecord
  belongs_to :customer
  belongs_to :review

  enum report_status: { wait: 0, hold: 1, complet: 2 }

end
