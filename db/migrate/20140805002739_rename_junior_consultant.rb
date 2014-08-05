class RenameJuniorConsultant < ActiveRecord::Migration
  def up
    remove_index :self_assessments, :junior_consultant_id
    remove_index :junior_consultants, :user_id

    rename_table :junior_consultants, :associate_consultants
    rename_column :reviews, :junior_consultant_id, :associate_consultant_id
    rename_column :self_assessments, :junior_consultant_id, :associate_consultant_id

    add_index :associate_consultants, :user_id
    add_index :self_assessments, :associate_consultant_id
  end

  def down
    remove_index :self_assessments, :associate_consultant_id
    remove_index :associate_consultants, :user_id

    rename_table :associate_consultants, :junior_consultants
    rename_column :reviews, :associate_consultant_id, :junior_consultant_id
    rename_column :self_assessments, :associate_consultant_id, :junior_consultant_id

    add_index :junior_consultants, :user_id
    add_index :self_assessments, :junior_consultant_id
  end
end
