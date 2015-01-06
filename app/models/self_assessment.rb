class SelfAssessment < ActiveRecord::Base
  attr_accessible :response, :review_id, :associate_consultant_id

  validates :associate_consultant, :presence => true
  validates :review, :presence => true
  validates :response, :presence => true

  belongs_to :review
  belongs_to :associate_consultant

  def review_happened_recently?
    review_deadline = review.review_date
    Date.today.between?(review_deadline, review_deadline + 2.weeks)
  end
end
