class CreateJuniorConsultants < ActiveRecord::Migration
  def change
    create_table :junior_consultants do |t|
      t.string :name
      t.string :email
      t.timestamps
    end
  end
end
