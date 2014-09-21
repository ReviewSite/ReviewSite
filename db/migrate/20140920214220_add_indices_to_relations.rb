class AddIndicesToRelations < ActiveRecord::Migration
  def up
    add_index :associate_consultants, :reviewing_group_id
    add_index :associate_consultants, :coach_id
    add_index :feedbacks, :user_id
    add_index :reviews, :associate_consultant_id
    add_index :reviewing_groups_users, [:user_id, :reviewing_group_id]
    add_index :reviewing_groups_users, :user_id
  end

  def down
    remove_index :associate_consultants, :reviewing_group_id
    remove_index :associate_consultants, :coach_id
    remove_index :feedbacks, :user_id
    remove_index :reviews, :associate_consultant_id
    remove_index :reviewing_groups_users, [:user_id, :reviewing_group_id]
    remove_index :reviewing_groups_users, :user_id
  end
end
