class AddCasNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cas_name, :string
  end
end
