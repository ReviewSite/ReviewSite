class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :junior_consultant_id
      t.string :review_type

      t.timestamps
    end
  end
end
