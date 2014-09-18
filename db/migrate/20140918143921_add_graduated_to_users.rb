class AddGraduatedToUsers < ActiveRecord::Migration
  def up
    add_column :associate_consultants, :graduated, :boolean
  end

  def down
    remove_column :associate_consultants, :graduated
  end
end
