class AddReportedByToFeedback < ActiveRecord::Migration
  def change
    add_column :feedbacks, :reported_by, :string
  end
end
