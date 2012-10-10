class Review < ActiveRecord::Base
  attr_accessible :junior_consultant_id, :review_type

  belongs_to :junior_consultant

  validates :review_type, :presence => true, :inclusion => { :in => %w(6-Month 12-Month 18-Month 24-Month) }
  validates :junior_consultant_id, :presence => true

  has_many :feedbacks

end
