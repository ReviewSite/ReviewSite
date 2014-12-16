class AdditionalEmail < ActiveRecord::Base
  include ModelsModule
  attr_accessible :user_id, :email, :confirmed_at
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :user_id, presence: true
  validate :must_be_thoughtworks_email
  devise :database_authenticatable, :confirmable
  belongs_to :user
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
