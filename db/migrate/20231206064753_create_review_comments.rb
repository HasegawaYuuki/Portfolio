class CreateReviewComments < ActiveRecord::Migration[6.1]
  def change
    create_table :review_comments do |t|
      t.integer :customer_id, null: false
      t.integer :review_id, null: false
      t.string :comment, null: false

      t.timestamps
    end
    add_reference :review_comments, :parent, foreign_key: { to_table: :review_comments }
  end
end
