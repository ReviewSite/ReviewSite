class AddUserStringToFeedback < ActiveRecord::Migration
  def change
    add_column :feedbacks, :user_string, :text
  end
end
