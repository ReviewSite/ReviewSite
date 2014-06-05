class DropReviewingGroupMembersTable < ActiveRecord::Migration
  def up
    drop_table :reviewing_group_members
  end

  def down
    create_table :reviewing_group_members do |t|
      t.integer :reviewing_group_id
      t.integer :user_id
      t.timestamps
    end
  end
end
