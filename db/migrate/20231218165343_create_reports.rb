class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.integer :customer_id, null: false
      t.integer :review_id, null: false
      t.text :report, null: false
      t.integer :report_status, default: 0

      t.timestamps
    end
  end
end
