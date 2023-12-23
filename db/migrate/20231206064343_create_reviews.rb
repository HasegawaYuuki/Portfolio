class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.integer :customer_id, null: false
      t.string :title, null: false
      t.string :sub_title
      t.text :body, null: false
      t.string :venue_name, null: false
      t.integer :status, null: false, default: 0
      t.date :date
      t.time :time

      t.timestamps
    end
  end
end
