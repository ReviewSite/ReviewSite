 class Invitation < ActiveRecord::Base
  belongs_to :review
  attr_accessible :email, :username

  THOUGHTWORKS_EMAIL = "thoughtworks.com"
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: { message: "Email cannot be blank." },
                    format: {
                      with: VALID_EMAIL_REGEX,
                      message: "%{value} could not be invited -- Invalid Email." },
                    uniqueness: {
                      case_sensitive: false,
                      scope: [:review_id],
                      message: "%{value} could not be invited -- Email already invited." }
  validate :has_no_feedback?
  validate :tw_email?

  def sent_date
    created_at.to_date
  end

  def user
    User.find_by_email(email) || find_user_by_additional_email(email)
  end

  def feedback
    Feedback.where(user_id: user, review_id: review_id).first
  end

  def delete_invite
    review.invitations.delete(self)
  end

  def sent_to?(user)
    if user.nil?
      false
    else
      user == self.user
    end
  end

  def reviewee
    review.associate_consultant
  end

  def expired?
    review.feedback_deadline < Date.today && feedback && feedback.submitted?
  end

  private

  def find_user_by_additional_email(primary_email)
    email = AdditionalEmail.find_by_email(primary_email)
    if email.present? && email.confirmed_at?
      email.user
    end
  end

  def has_no_feedback?
    if feedback
      errors.clear
      errors.add(:review, "#{user.email} has already given feedback for this review.")
    end
  end

  def tw_email?
    if email && errors[:email].empty? && email.exclude?(THOUGHTWORKS_EMAIL)
      errors.add(:email,"#{email} could not be invited -- Not a ThoughtWorks Email.")
    end
  end
end
