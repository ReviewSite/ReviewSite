class AddUserIdToJuniorConsultants < ActiveRecord::Migration
  def up
    add_column :junior_consultants, :user_id, :integer
    add_index :junior_consultants, :user_id
  end

  def down
    execute <<-SQL
      UPDATE junior_consultants SET user_id = NULL;
    SQL

    remove_column :junior_consultants, :user_id
    remove_index :junior_consultants, :user_id
  end
end
