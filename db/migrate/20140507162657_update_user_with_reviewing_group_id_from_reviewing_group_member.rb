class UpdateUserWithReviewingGroupIdFromReviewingGroupMember < ActiveRecord::Migration
  def up

    execute <<-SQL
      UPDATE users
      SET reviewing_group_id = ( SELECT reviewing_group_id
                                 FROM reviewing_group_members
                                 WHERE users.id = reviewing_group_members.user_id );
    SQL

  end


  def down
    
    execute <<-SQL
      UPDATE users
      SET reviewing_group_id = null;
    SQL

  end

end
