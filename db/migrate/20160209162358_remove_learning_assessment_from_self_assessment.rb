class RemoveLearningAssessmentFromSelfAssessment < ActiveRecord::Migration
  def up
    remove_column :self_assessments, :learning_assessment
  end

  def down
    add_column :self_assessments, :learning_assessment, :text
  end
end
