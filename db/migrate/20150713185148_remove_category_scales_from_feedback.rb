class RemoveCategoryScalesFromFeedback < ActiveRecord::Migration
  def up
    remove_column :feedbacks, :role_competence_scale
    remove_column :feedbacks, :consulting_skills_scale
    remove_column :feedbacks, :teamwork_scale
    remove_column :feedbacks, :contributions_scale
  end

  def down
    add_column :feedbacks, :role_competence_scale, :integer
    add_column :feedbacks, :consulting_skills_scale, :integer
    add_column :feedbacks, :teamwork_scale, :integer
    add_column :feedbacks, :contributions_scale, :integer
  end
end