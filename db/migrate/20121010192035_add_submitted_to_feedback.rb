class AddSubmittedToFeedback < ActiveRecord::Migration
  def change
    add_column :feedbacks, :submitted, :boolean, :default => false
  end
end
