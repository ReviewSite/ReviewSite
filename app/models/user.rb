class User < ActiveRecord::Base
  include ModelsModule
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_accessible \
      :name,
      :okta_name,
      :email,
      :admin,
      :associate_consultant_attributes

  has_many :feedbacks
  has_many :coachees, class_name:'AssociateConsultant', foreign_key: 'coach_id'
  has_many :additional_emails, class_name: 'AdditionalEmail',
    foreign_key: 'user_id', dependent: :destroy

  has_one :associate_consultant, dependent: :destroy
  has_and_belongs_to_many :reviewing_groups

  accepts_nested_attributes_for :associate_consultant, reject_if: :all_blank
  accepts_nested_attributes_for :additional_emails

  validates :name, presence: true,
                   length: { minimum: 2, maximum: 50 }
  validates :okta_name, presence:   true,
                        uniqueness: { case_sensitive: false },
                        length:     { minimum: 2, maximum: 10 }
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  before_save      :downcase_email
  after_validation :check_errors

  def to_s
    self.name
  end

  def all_emails
    [self.email] + self.additional_emails.select(&:confirmed_at).map(&:email)
  end

  def ac?
    self.associate_consultant.present? && self.associate_consultant.persisted?
  end

  private

  def check_errors
    update_errors(self)
  end

  def downcase_email
    self.email = self.email.downcase
  end
end
