class ChangeColumnNameInJc < ActiveRecord::Migration
  def change
    rename_column :junior_consultants, :coach, :coach_id
  end
end
