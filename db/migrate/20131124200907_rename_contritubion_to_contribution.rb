class RenameContritubionToContribution < ActiveRecord::Migration
  def change
    rename_column :feedbacks, :contritubions_went_well, :contributions_went_well
    rename_column :feedbacks, :contritubions_to_be_improved, :contributions_to_be_improved
    rename_column :feedbacks, :contritubions_action_items, :contributions_action_items
    rename_column :feedbacks, :contritubions_scale, :contributions_scale
  end
end
