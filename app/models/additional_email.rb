class AdditionalEmail < ActiveRecord::Base
  include ModelsModule

  THOUGHTWORKS_EMAIL = "thoughtworks.com"
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  devise :database_authenticatable, :confirmable

  attr_accessible :user_id, :email, :confirmed_at

  belongs_to :user

  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :user_id, presence: true
  validate  :must_be_thoughtworks_email
  validate  :uniqueness_of_email

  after_validation :check_errors

  private

  def check_errors
    update_errors(self)
  end

  def must_be_thoughtworks_email
    if email.exclude? THOUGHTWORKS_EMAIL
      errors.add(:email, "must be a ThoughtWorks email")
    end
  end

  def uniqueness_of_email
    if User.find_by_email(email).present?
      errors.add(:email, "this email has already been taken")
    end
  end
end
