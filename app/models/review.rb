class Review < ActiveRecord::Base
  attr_accessible :junior_consultant_id, :review_type

  validates :review_type, :presence => true
  validates :junior_consultant_id, :presence => true
end
