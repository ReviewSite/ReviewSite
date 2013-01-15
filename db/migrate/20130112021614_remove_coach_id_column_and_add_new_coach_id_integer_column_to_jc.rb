class RemoveCoachIdColumnAndAddNewCoachIdIntegerColumnToJc < ActiveRecord::Migration
  def change
    remove_column :junior_consultants, :coach_id
    add_column :junior_consultants, :coach_id, :integer
  end
end
