require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessible :name, :okta_name, :email, :start_date
  attr_protected :password_reset_token, :password_reset_sent_at, :password_digest

  has_many :coachees, :class_name => "AssociateConsultant", :foreign_key => "coach_id"
  has_one :associate_consultant, :dependent => :destroy
  has_many :feedbacks
  has_and_belongs_to_many :reviewing_groups

  accepts_nested_attributes_for :associate_consultant, :reject_if => :all_blank

  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :okta_name, presence:   true,
                       uniqueness: { case_sensitive: false },
                       length:     { minimum: 2, maximum: 10 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  before_save { |user| user.email = user.email.downcase }

  def to_s
    self.name
  end

  def ac?
    !self.associate_consultant.nil? && self.associate_consultant.persisted?
  end

  def request_password_reset
    self.update_column(:password_reset_token, SecureRandom.urlsafe_base64)
    self.update_column(:password_reset_sent_at, Time.zone.now)
    UserMailer.password_reset(self).deliver
  end

  def authenticate(unencrypted_password)
    if has_password? and matches_password?(unencrypted_password)
      self
    else
      false
    end
  end

  private
  def has_password?
    not password_digest.nil?
  end

  def matches_password?(unencrypted_password)
    BCrypt::Password.new(password_digest) == unencrypted_password
  end
end
