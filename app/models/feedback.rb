class Feedback < ActiveRecord::Base
  attr_accessible :attitude_exceeded, :attitude_improve, :attitude_met, :client_exceeded, :client_improve, :client_met, :comments, :innovative_exceeded, :innovative_improve, :innovative_met, :leadership_exceeded, :leadership_improve, :leadership_met, :organizational_exceeded, :organizational_improve, :organizational_met, :ownership_exceeded, :ownership_improve, :ownership_met, :professionalism_exceeded, :professionalism_improve, :professionalism_met, :project_worked_on, :review_id, :role_description, :teamwork_exceeded, :teamwork_improve, :teamwork_met, :tech_exceeded, :tech_improve, :tech_met, :user_id

  validates :review_id, :presence => true
  validates :user_id, :presence => true

  validates :review_id, :uniqueness => {:scope => [:user_id]}

  belongs_to :review
  belongs_to :user
end
