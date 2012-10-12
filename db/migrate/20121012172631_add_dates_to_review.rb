class AddDatesToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :review_date, :date
    add_column :reviews, :feedback_deadline, :date
    add_column :reviews, :send_link_date, :date
  end
end
