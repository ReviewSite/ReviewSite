class AddNotesToConsultant < ActiveRecord::Migration
  def change
    add_column :junior_consultants, :notes, :text
  end
end
