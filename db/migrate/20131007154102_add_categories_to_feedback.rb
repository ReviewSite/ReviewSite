class AddCategoriesToFeedback < ActiveRecord::Migration
  def change
    add_column :feedbacks, :role_competence_went_well, :text
    add_column :feedbacks, :role_competence_to_be_improved, :text
    add_column :feedbacks, :role_competence_action_items, :text
    add_column :feedbacks, :consulting_skills_went_well, :text
    add_column :feedbacks, :consulting_skills_to_be_improved, :text
    add_column :feedbacks, :consulting_skills_action_items, :text
    add_column :feedbacks, :teamwork_went_well, :text
    add_column :feedbacks, :teamwork_to_be_improved, :text
    add_column :feedbacks, :teamwork_action_items, :text
    add_column :feedbacks, :contritubions_went_well, :text
    add_column :feedbacks, :contritubions_to_be_improved, :text
    add_column :feedbacks, :contritubions_action_items, :text
  end
end
