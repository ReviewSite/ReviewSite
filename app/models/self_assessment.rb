class SelfAssessment < ActiveRecord::Base
  belongs_to :review
  belongs_to :junior_consultant
  attr_accessible :response
end
