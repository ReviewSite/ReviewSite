class Review < ActiveRecord::Base
  include ModelsModule

  REVIEW_TYPES = %w(6-Month 12-Month 18-Month 24-Month)

  attr_accessible \
      :associate_consultant_id,
      :feedback_deadline,
      :review_date,
      :review_type

  validates :review_type, presence: true, inclusion: { in: REVIEW_TYPES }
  validates :associate_consultant_id, presence: true
  validates :associate_consultant_id, uniqueness: { scope: [:review_type] }
  validates :feedback_deadline, presence: true
  validates :review_date, presence: true

  validate :feedback_deadline_is_before_review_date, if: :review_and_feedback_deadline_present?

  belongs_to :associate_consultant

  has_many :feedbacks,        dependent: :destroy
  has_many :self_assessments, dependent: :destroy
  has_many :invitations,      dependent: :destroy
  has_one :reviewee, through: :associate_consultant, source: :user

  after_validation :check_errors
  after_initialize :set_new_review_format

  def self.default_load
    includes( :reviewee, associate_consultant: :reviewing_group )
  end

  def self.create_default_reviews(associate, reviews = [])
    [6, 12, 18, 24].each do |n|
      review_params = {
        associate_consultant_id: associate.id,
        review_type: "#{n}-Month",
        review_date: associate.program_start_date + n.months,
        feedback_deadline: associate.program_start_date + n.months - 7.days
      }

      reviews << Review.create(review_params)
    end
    reviews
  end

  def in_the_future?
    self.review_date.present? && self.review_date > Date.today
  end

  def questions
    @questions ||= QuestionBuilder.build(associate_consultant)
  end

  def headings
    if self.new_review_format
      Review::Heading::NEW_FORMAT
    else
      Review::Heading::OLD_FORMAT
    end
  end

  def heading_title(heading)
    questions[heading].title if questions[heading].present?
  end

  def description(heading)
    result = ""
    if questions[heading].present?
      if heading != "Comments"
       result += "<p>Here are some questions to consider... </p>"
      end
      result += questions[heading].description
    end
    result
  end

  def fields_for_heading(heading)
    if questions[heading].present?
      questions[heading].fields
    else
      []
    end
  end

  def prepare_heading_html_attribute(heading)
    heading.downcase.gsub(/\s/,'-')
  end

  def is_comments_header(heading)
    heading == "Comments"
  end

  def to_s
    self.pretty_print_with(nil)
  end

  def pretty_print_with(user)
    if user.present? && user == self.reviewee
      "Your #{review_type} Review"
    else
      "#{self.reviewee.name}'s #{review_type} Review"
    end
  end

  def has_existing_feedbacks?
    feedbacks.size > 0
  end

  def upcoming?
    review_date.present? && self == associate_consultant.upcoming_review
  end

  private

  def check_errors
    update_errors(self)
  end

  def set_new_review_format
    self.new_review_format = true if new_record?
  end

  def feedback_deadline_is_before_review_date
    if self.feedback_deadline >= self.review_date
      self.errors.add(:feedback_deadline, "must be before Review Date.")
    end
  end

  def review_and_feedback_deadline_present?
    self.feedback_deadline.present? && self.review_date.present?
  end
end
