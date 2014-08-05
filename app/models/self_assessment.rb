class SelfAssessment < ActiveRecord::Base
  attr_accessible :response, :review_id, :associate_consultant_id

  validates :associate_consultant, :presence => true
  validates :review, :presence => true

  belongs_to :review
  belongs_to :associate_consultant
end
