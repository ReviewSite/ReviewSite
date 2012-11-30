class CreateSelfAssessments < ActiveRecord::Migration
  def change
    create_table :self_assessments do |t|
      t.references :review
      t.references :junior_consultant
      t.text :response

      t.timestamps
    end
    add_index :self_assessments, :review_id
    add_index :self_assessments, :junior_consultant_id
  end
end
