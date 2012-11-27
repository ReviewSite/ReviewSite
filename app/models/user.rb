class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password


  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
            format:     { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  before_save { |user| user.email = user.email.downcase }
  before_save :create_remember_token
  delegate :can?, :cannot?, :to => :ability

  def to_s
    self.name
  end

  def ability
    @ability ||= Ability.new(self)
  end

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
