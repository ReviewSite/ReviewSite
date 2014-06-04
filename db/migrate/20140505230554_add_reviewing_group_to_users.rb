class AddReviewingGroupToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reviewing_group_id, :integer
    add_index :users, :reviewing_group_id
  end
end
