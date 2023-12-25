class CreateTaggings < ActiveRecord::Migration[6.1]
  def change
    create_table :taggings do |t|
      t.integer :tag_id, null: false, foreign_key: true
      t.integer :review_id, null: false, foreign_key: true

      t.timestamps
    end
    # 同じタグは２回保存出来ない
    add_index :taggings, [:tag_id,:review_id],unique: true
  end
end
