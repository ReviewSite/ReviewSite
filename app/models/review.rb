class Review < ActiveRecord::Base
  attr_accessible :junior_consultant_id, :review_type, :review_date, :feedback_deadline, :send_link_date

  belongs_to :junior_consultant

  validates :review_type, :presence => true, :inclusion => { :in => %w(6-Month 12-Month 18-Month 24-Month) }
  validates :junior_consultant_id, :presence => true
  validates :junior_consultant_id, :uniqueness => {:scope => [:review_type]}
  validates :feedback_deadline, :presence => true

  has_many :feedbacks, :dependent => :destroy
  has_many :self_assessments, :dependent => :destroy
  has_many :invitations, :dependent => :destroy

  after_initialize :init

  def init
    self.new_review_format = true if new_record?
  end

  def headings
    if self.new_review_format
      ["Role Competence","Consulting Skills","Teamwork", "Contritubions"]
    else
      ["Tech","Client", "Ownership", "Leadership", "Teamwork", "Attitude", "Professionalism", "Organizational", "Innovative"]
    end
  end
  def headers
    if self.new_review_format
      ["role_competence_went_well", "role_competence_to_be_improved", "role_competence_action_items",
        "consulting_skills_went_well", "consulting_skills_to_be_improved", "consulting_skills_action_items",
        "teamwork_went_well", "teamwork_to_be_improved", "teamwork_action_items",
        "contritubions_went_well", "contritubions_to_be_improved", "contritubions_action_items"]
    else
      ["tech_exceeded", "tech_met", "tech_improve",
        "client_exceeded", "client_met", "client_improve",
        "ownership_exceeded", "ownership_met", "ownership_improve",
        "leadership_exceeded", "leadership_met", "leadership_improve",
        "teamwork_exceeded", "teamwork_met", "teamwork_improve",
        "attitude_exceeded", "attitude_met", "attitude_improve",
        "professionalism_exceeded", "professionalism_met", "professionalism_improve",
        "organizational_exceeded", "organizational_met", "organizational_improve",
        "innovative_exceeded", "innovative_met", "innovative_improve"]
    end
  end

  def to_s
    "#{junior_consultant} - #{review_type}"
  end

end
