class Review < ActiveRecord::Base
  attr_accessible :junior_consultant_id, :review_type, :review_date, :feedback_deadline, :send_link_date

  belongs_to :junior_consultant

  validates :review_type, :presence => true, :inclusion => { :in => %w(6-Month 12-Month 18-Month 24-Month) }
  validates :junior_consultant_id, :presence => true
  validates :junior_consultant_id, :uniqueness => {:scope => [:review_type]}

  has_many :feedbacks, :dependent => :destroy

  def self.readable_and_sumarizeable_for_user(user)
    all.inject([]) { |memo, review|
      memo << review if user.can? :read, review or user.can? :summary, review
      memo
    }.sort
  end

  def to_s
    junior_consultant.to_s + " - " + review_type
  end

  def <=>(other)
    return 1 if self.review_date.nil?
    self.review_date <=> other.review_date
  end
end
