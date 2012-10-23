class ReviewingGroupMember < ActiveRecord::Base
  attr_accessible :reviewing_group_id, :user_id

  belongs_to :reviewing_group
  belongs_to :user

  validates :user_id, :presence => true
  validates :reviewing_group_id, :presence => true
end
