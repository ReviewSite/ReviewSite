class ReviewingGroup < ActiveRecord::Base
  attr_accessible :name

  has_many :reviewing_group_members, :dependent => :destroy

  validates :name, presence: true

  accepts_nested_attributes_for :reviewing_group_members

  def members
    self.reviewing_group_members.map { |m| m.to_s}.join(',')
  end

  def to_s
    self.name
  end

end
