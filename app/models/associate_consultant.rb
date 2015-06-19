class AssociateConsultant < ActiveRecord::Base
  attr_accessible :notes, :reviewing_group_id, :coach_id, :user_id, :associate_consultant_id, :graduated, :program_start_date

  belongs_to :reviewing_group
  belongs_to :coach, class_name: "User", foreign_key: :coach_id
  belongs_to :user, foreign_key: :user_id
  has_many :reviews, dependent: :destroy

  scope :not_graduated, -> { where(graduated: false) }

  validates :coach_id, numericality: { only_integer: true }, allow_blank: true
  validates :reviewing_group_id, numericality: { only_integer: true, message: "can't be blank." }, allow_blank: false

  def to_s
    self.user.name
  end

  def upcoming_review
    date_range = Date.today..(Date.today + 6.months)
    self.reviews.where("review_date" => date_range).order(:review_date).first
  end

  def can_graduate?
    has_not_graduated? && graduation_date_in_the_past?
  end

  def has_graduated?
    self.graduated?
  end

  def has_not_graduated?
    !self.graduated?
  end

  def blank?
    self.reviewing_group_id.blank? &&
      self.coach_id.blank? &&
      self.graduated.blank? &&
      self.program_start_date.blank? &&
      self.notes.blank?
  end

  private

  def graduation_date_in_the_past?
    if graduation_date.present?
      Date.today > graduation_date
    else
      false
    end
  end

  def graduation_date
    reviews = self.reviews.where(review_type:'24-Month')
    if reviews.any?
      reviews.first.review_date
    end
  end
end
