class CreateReviewingGroupMembers < ActiveRecord::Migration
  def change
    create_table :reviewing_group_members do |t|
      t.integer :reviewing_group_id
      t.integer :user_id

      t.timestamps
    end
  end
end
