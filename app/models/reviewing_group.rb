class ReviewingGroup < ActiveRecord::Base
  attr_accessible :name

  has_many :reviewing_group_members, :dependent => :destroy

  validates :name, presence: true

  accepts_nested_attributes_for :reviewing_group_members
end
