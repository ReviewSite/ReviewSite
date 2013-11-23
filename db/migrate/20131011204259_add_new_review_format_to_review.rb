class AddNewReviewFormatToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :new_review_format, :boolean, :default => false
  end
end
