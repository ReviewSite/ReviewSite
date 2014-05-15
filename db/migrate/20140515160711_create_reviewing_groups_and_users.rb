class CreateReviewingGroupsAndUsers < ActiveRecord::Migration
  def change

    create_table :reviewing_groups_users, id: false do |t|
      t.belongs_to :reviewing_group
      t.belongs_to :user
    end

  end
end
