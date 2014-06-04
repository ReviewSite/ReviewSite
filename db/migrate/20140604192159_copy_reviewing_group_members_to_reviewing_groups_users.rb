class CopyReviewingGroupMembersToReviewingGroupsUsers < ActiveRecord::Migration
   def up
     execute <<-SQL
       INSERT INTO reviewing_groups_users (user_id, reviewing_group_id) 
       SELECT user_id, reviewing_group_id 
       FROM reviewing_group_members;
     SQL
   end

   def down
     execute <<-SQL
       DELETE FROM reviewing_groups_users;
     SQL
   end
end
