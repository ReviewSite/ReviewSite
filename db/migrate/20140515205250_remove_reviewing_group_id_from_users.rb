class RemoveReviewingGroupIdFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :reviewing_group_id
  end

  def down
    add_column :users, :reviewing_group_id, :integer
    add_index :users, :reviewing_group_id
  end
end
