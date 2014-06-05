class CreateReviewingGroupsAndUsers < ActiveRecord::Migration
  def up
    create_table :reviewing_groups_users, id: false do |t|
      t.belongs_to :reviewing_group
      t.belongs_to :user
    end
  end

  def down
    drop_table :reviewing_groups_users
  end
end
