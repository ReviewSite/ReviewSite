class InsertIdsIntoReviewingGroupsUsers < ActiveRecord::Migration
  def up
    execute <<-SQL
      INSERT INTO reviewing_groups_users
      SELECT reviewing_group_id, id
      FROM users
      WHERE reviewing_group_id IS NOT NULL;
    SQL
  end

  def down
    execute <<-SQL
      DELETE FROM reviewing_groups_users
    SQL
  end
end
