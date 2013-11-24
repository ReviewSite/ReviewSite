class AddCategoryScalesToFeedback < ActiveRecord::Migration
  def change
    add_column :feedbacks, :role_competence_scale, :integer
    add_column :feedbacks, :consulting_skills_scale, :integer
    add_column :feedbacks, :teamwork_scale, :integer
    add_column :feedbacks, :contritubions_scale, :integer
  end
end
