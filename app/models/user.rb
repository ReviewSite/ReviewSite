class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password
  has_many :junior_consultants

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
            format:     { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  before_save { |user| user.email = user.email.downcase }
  before_save :create_remember_token

  def to_s
    self.name
  end

  def request_password_reset
    self.update_attribute(:password_reset_token, SecureRandom.urlsafe_base64)
    self.update_attribute(:password_reset_sent_at, Time.zone.now)
    UserMailer.password_reset(self)
  end

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
