class RemoveNameAndEmailFromJuniorConsultant < ActiveRecord::Migration
  def change
    remove_column :junior_consultants, :name
    remove_column :junior_consultants, :email
  end
end
