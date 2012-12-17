class SelfAssessment < ActiveRecord::Base
  attr_accessible :response, :review_id, :junior_consultant_id

  validates :junior_consultant, :presence => true
  validates :review, :presence => true

  belongs_to :review
  belongs_to :junior_consultant
end
