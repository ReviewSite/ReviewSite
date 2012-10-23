class AddReviewGroupToJuniorConsultant < ActiveRecord::Migration
  def change
    add_column :junior_consultants, :reviewing_group_id, :integer
  end
end
