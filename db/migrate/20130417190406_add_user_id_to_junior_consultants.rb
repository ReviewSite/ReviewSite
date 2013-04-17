class AddUserIdToJuniorConsultants < ActiveRecord::Migration
  def change
    add_column :junior_consultants, :user_id, :integer
    add_index :junior_consultants, :user_id
    JuniorConsultant.reset_column_information
    JuniorConsultant.all.each do |jc|
      user = User.find_by_email(jc.email)
      jc.assign_attributes({:user_id => user.id}, :without_protection => true)
      jc.save(:validate => false)
    end
  end
end
