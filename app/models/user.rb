class User < ActiveRecord::Base
  attr_accessible :name, :cas_name, :email, :password, :password_confirmation
  attr_protected :password_reset_token, :password_reset_sent_at
  has_secure_password
  has_many :junior_consultants
  has_many :feedbacks

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :cas_name, presence: true, uniqueness: {case_sensitive: false}
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
    self.update_column(:password_reset_token, SecureRandom.urlsafe_base64)
    self.update_column(:password_reset_sent_at, Time.zone.now)
    UserMailer.password_reset(self).deliver
  end

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
