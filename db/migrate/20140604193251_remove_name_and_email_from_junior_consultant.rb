class RemoveNameAndEmailFromJuniorConsultant < ActiveRecord::Migration
  def up
    remove_column :junior_consultants, :name
    remove_column :junior_consultants, :email
  end

  def down
    add_column :junior_consultants, :name, :string
    add_column :junior_consultants, :email, :string
  end
end
