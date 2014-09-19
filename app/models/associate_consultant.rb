class AssociateConsultant < ActiveRecord::Base
  attr_accessible :notes, :reviewing_group_id, :coach_id, :user_id, :associate_consultant_id, :graduated

  belongs_to :reviewing_group
  belongs_to :coach, :class_name => "User", :foreign_key => :coach_id
  belongs_to :user, :foreign_key => :user_id
  has_many :reviews, :dependent => :destroy

  validates :coach_id, :numericality => { :only_integer => true }, :allow_blank => true
  validates :reviewing_group_id, :numericality => { :only_integer => true }, :allow_blank => false

  def to_s
    self.user.name
  end

  def upcoming_review
    date_range = Date.today..(Date.today + 6.months)
    self.reviews.where('review_date' => date_range).first
  end

  def hasGraduated?
    !self.graduated.nil? && self.graduated
  end
end
