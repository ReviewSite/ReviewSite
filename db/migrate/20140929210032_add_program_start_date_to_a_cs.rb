class AddProgramStartDateToACs < ActiveRecord::Migration
  def up
    add_column :associate_consultants, :program_start_date, :date
  end

  def down
    remove_column :associate_consultants, :program_start_date
  end
end
