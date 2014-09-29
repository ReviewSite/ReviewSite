 class Invitation < ActiveRecord::Base
  belongs_to :review
  attr_accessible :email, :username

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false, scope: [:review_id] }

  def sent_date
    created_at.to_date
  end

  def user
    User.find_by_email(email)
  end

  def feedback
    review.feedbacks.includes(:user).each do |f|
      return f if f.user == user
    end
    nil
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
