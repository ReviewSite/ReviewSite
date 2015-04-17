class SelfAssessment < ActiveRecord::Base
  attr_accessible \
    :response,
    :review_id,
    :associate_consultant_id,
    :learning_assessment

  belongs_to :review
  belongs_to :associate_consultant

  validates :associate_consultant, presence: true
  validates :review,   presence: true
  validates :response, presence: true

  if false
    validates :learning_assessment, presence: true
  end

  def review_happened_recently?
    in_next_two_weeks?(review.review_date)
  end

  private

  def in_next_two_weeks?(date)
    Date.today.between?(date, date + 2.weeks)
  end
end
