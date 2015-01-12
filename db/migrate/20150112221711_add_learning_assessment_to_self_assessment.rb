class AddLearningAssessmentToSelfAssessment < ActiveRecord::Migration
  def change
    add_column :self_assessments, :learning_assessment, :text
  end
end
