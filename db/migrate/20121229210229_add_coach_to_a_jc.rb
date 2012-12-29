class AddCoachToAJc < ActiveRecord::Migration
  def change
    add_column :junior_consultants, :coach, :string
  end
end
