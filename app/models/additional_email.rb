class AdditionalEmail < ActiveRecord::Base
  include ModelsModule
  attr_accessible :user_id, :email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validate :must_be_thoughtworks_email
  after_validation :check_errors

  def must_be_thoughtworks_email
    if !email.include? "thoughtworks.com"
      errors.add(:email, "must be a ThoughtWorks email")
    end
  end

  private

    def check_errors
      update_errors(self)
    end
end
