class DropReviewingGroupMembersTable < ActiveRecord::Migration
  def change
    drop_table :reviewing_group_members
  end
end
