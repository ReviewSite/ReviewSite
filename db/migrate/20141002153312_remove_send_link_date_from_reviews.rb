class RemoveSendLinkDateFromReviews < ActiveRecord::Migration
  def up
    remove_column :reviews, :send_link_date
  end

  def down
    add_column :reviews, :send_link_date, :date
  end
end
