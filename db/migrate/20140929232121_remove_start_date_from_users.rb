class RemoveStartDateFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :start_date
  end

  def down
    add_column :users, :start_date, :date
  end
end
