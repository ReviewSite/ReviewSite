class ReviewingGroup < ActiveRecord::Base
  attr_accessible :name, :users_attributes

  has_many :reviewing_group_members, :dependent => :destroy
  has_many :users, :dependent => :nullify

  validates :name, presence: true

  accepts_nested_attributes_for :reviewing_group_members
  accepts_nested_attributes_for :users

  def members
    self.users.map { |m| m.to_s}.join(', ')
  end

  def to_s
    self.name
  end

end
