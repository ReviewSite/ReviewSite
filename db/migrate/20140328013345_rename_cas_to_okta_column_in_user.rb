class RenameCasToOktaColumnInUser < ActiveRecord::Migration
  def up
    rename_column :users, :cas_name, :okta_name
  end

  def down
    rename_column :users, :okta_name, :cas_name
  end
end
