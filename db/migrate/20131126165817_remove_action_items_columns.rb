class RemoveActionItemsColumns < ActiveRecord::Migration
  def up
    remove_column :feedbacks, :role_competence_action_items
    remove_column :feedbacks, :consulting_skills_action_items
    remove_column :feedbacks, :teamwork_action_items
    remove_column :feedbacks, :contributions_action_items
  end

  def down
    add_column :feedbacks, :role_competence_action_items, :text
    add_column :feedbacks, :consulting_skills_action_items, :text
    add_column :feedbacks, :teamwork_action_items, :text
    add_column :feedbacks, :contributions_action_items, :text
  end
end
