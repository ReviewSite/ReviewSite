 class Invitation < ActiveRecord::Base
  belongs_to :review
  attr_accessible :email, :username

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

  def tw_email?
    if email && !errors[:email].any? && !email.include?("@thoughtworks.com")
      errors.add(:email,"#{email} could not be invited -- Not a ThoughtWorks Email.")
    end
  end

  def has_no_feedback?
    if feedback
      errors.clear
      errors.add(:review, "#{user.email} has already given feedback for this review.")
    end
  end

  def sent_date
    created_at.to_date
  end

  def user
    user = User.find_by_email(email)
    if !user.nil?
      user
    else
     email = AdditionalEmail.find_by_email(email)
     if !email.nil?
       User.find(email.user_id)
     end
   end
  end

  def feedback
    review.feedbacks.includes(:user).each do |f|
      return f if f.user == user
    end
    nil
  end

  def delete_invite
      review.invitations.delete(self)
  end

  def sent_to?(user)
    return false if user.nil?
    user == self.user
  end

  def reviewee
    review.associate_consultant
  end

  def expired?
    review.feedback_deadline < Date.today and feedback and feedback.submitted?
  end
end
