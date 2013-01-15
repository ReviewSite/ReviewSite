class ChangeColumnNameInJc < ActiveRecord::Migration
  def change
    rename_column :junior_consultants, :coach, :coach_id
    change_column :junior_consultants, :coach_id, :integer
  end
end
