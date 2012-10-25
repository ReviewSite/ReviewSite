class JuniorConsultant < ActiveRecord::Base
  attr_accessible :name, :email, :notes, :reviewing_group_id
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
            format:     { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  before_save { |user| user.email = user.email.downcase }

  belongs_to :reviewing_group

  has_many :reviews, :dependent => :destroy

  def to_s
    self.name
  end
end
