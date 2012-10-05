class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :user_id
      t.string :project_worked_on
      t.string :role_description
      t.text :tech_exceeded
      t.text :tech_met
      t.text :tech_improve
      t.text :client_exceeded
      t.text :client_met
      t.text :client_improve
      t.text :ownership_exceeded
      t.text :ownership_met
      t.text :ownership_improve
      t.text :leadership_exceeded
      t.text :leadership_met
      t.text :leadership_improve
      t.text :teamwork_exceeded
      t.text :teamwork_met
      t.text :teamwork_improve
      t.text :attitude_exceeded
      t.text :attitude_met
      t.text :attitude_improve
      t.text :professionalism_exceeded
      t.text :professionalism_met
      t.text :professionalism_improve
      t.text :organizational_exceeded
      t.text :organizational_met
      t.text :organizational_improve
      t.text :innovative_exceeded
      t.text :innovative_met
      t.text :innovative_improve
      t.text :comments
      t.integer :review_id

      t.timestamps
    end
  end
end
