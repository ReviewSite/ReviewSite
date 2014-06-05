class JuniorConsultant < ActiveRecord::Base
  attr_accessible :notes, :reviewing_group_id, :coach_id, :user_id, :junior_consultant_id

  belongs_to :reviewing_group
  belongs_to :coach, :class_name => "User", :foreign_key => :coach_id
  belongs_to :user, :foreign_key => :user_id
  has_many :reviews, :dependent => :destroy

  validates :coach_id, :numericality => { :only_integer => true }, :allow_blank => true
  validates :reviewing_group_id, :numericality => { :only_integer => true }, :allow_blank => false

  def to_s
    self.user.name
  end
end
