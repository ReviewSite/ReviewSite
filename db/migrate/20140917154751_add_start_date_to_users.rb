class AddStartDateToUsers < ActiveRecord::Migration
  def up
    add_column :users, :start_date, :date
  end

  def down
    remove_column :users, :start_date
  end
end
