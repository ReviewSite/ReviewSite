class Review < ActiveRecord::Base
  attr_accessible :junior_consultant_id, :review_type, :review_date, :feedback_deadline, :send_link_date

  belongs_to :junior_consultant

  validates :review_type, :presence => true, :inclusion => { :in => %w(6-Month 12-Month 18-Month 24-Month) }
  validates :junior_consultant_id, :presence => true
  validates :junior_consultant_id, :uniqueness => {:scope => [:review_type]}
  # validates :feedback_deadline, :presence => true

  has_many :feedbacks, :dependent => :destroy
  has_many :self_assessments, :dependent => :destroy
  has_many :invitations, :dependent => :destroy

  after_initialize :init

  def init
    self.new_review_format = true if new_record?
  end

  class Question
    attr_accessor :heading, :title, :fields, :description, :scale_field

    def initialize(heading, title, fields, description, scale_field = nil)
      @heading = heading
      @title = title
      @fields = fields
      @description = description
      @scale_field = scale_field
    end
  end

  def questions
    questions = {}

    # old-style questions
    questions["Tech"] = Question.new("Tech", "Technical Competence", ["tech_exceeded", "tech_met", "tech_improve"],
                                     "<p>Aptitude/ knowledge/ skills <br />" +
                                     "Able to understand the application?<br />" +
                                     "Able to apply existing knowledge and skills during development/analysis?<br />" +
                                     "Keen on learning new languages/tools/applications?<br />" +
                                     "Share knowledge with other team members as and when required?<br />" +
                                     "Self-driven?</p>")
    questions["Client"] = Question.new("Client", "Client Interaction", ["client_exceeded", "client_met", "client_improve"],
                                       "<p>Presentation/showcase skills, ability to handle unreasonable demands, suggest alternative solutions, negotiation, body language during client interactions</p>")
    questions["Ownership"] = Question.new("Ownership", "Ownership/Delivery focus", ["ownership_exceeded", "ownership_met", "ownership_improve"],
                                          "<p>Understands the need to deliver on time,  stretches to deliver if need be, accountability on stories that they have/are working on, dependability</p>")
    questions["Leadership"] = Question.new("Leadership", "Leadership", ["leadership_exceeded", "leadership_met", "leadership_improve"],
                                           "<p>Proactive, leads by example, motivates etc. <br />" +
                                           "Mentoring: Bringing new team members up to speed, work with existing team members on areas that they find difficult to understand</p>")
    questions["OldTeamwork"] = Question.new("OldTeamwork", "Teamwork", ["teamwork_exceeded", "teamwork_met", "teamwork_improve"],
                                         "<p>Building relationships and working with team members, Updates to team, Pairing, internal communication/sharing feedback right and on time</p>")
    questions["Attitude"] = Question.new("Attitude", "Attitude", ["attitude_exceeded", "attitude_met", "attitude_improve"],
                                         "<p>Energy, Enthusiasm, Co-operative, Helpful, Approachable</p>")
    questions["Professionalism"] = Question.new("Professionalism", "Professionalism", ["professionalism_exceeded", "professionalism_met", "professionalism_improve"],
                                               "<p>Punctuality wrt Standups/ team meetings/ timesheet submission, planning and informing absence, professional conduct, ability to handle difficult team members/clients, conflict resolution</p>")
    questions["Organizational"] = Question.new("Organizational", "Organizational Involvement", ["organizational_exceeded", "organizational_met", "organizational_improve"],
                                               "<p>P1/P2: User groups, mailing lists, JC Learning Sessions, HOD, Away Day, lunch & learns</p>" +
                                               "<p>P3/social Justice: Aware/Actively involved in SIP, townhall discussions, TW sponsored events such as Black Girls Code, Rails Girls, etc., volunteerism outside of TW, global events </p>" +
                                               "<p>Recruiting, Code Reviews, team dinners, pub night, my.thoughtworks.com</p>")
    questions["Innovative"] = Question.new("Innovative", "Innovation/Out of the box thinking", ["innovative_exceeded", "innovative_met", "innovative_improve"],
                                           "<p>Simple new ideas that made lives easier on the project or clients/ unique innovative solutions in or outside of projects</p>")

    # new-style questions
    questions["Role Competence"] = Question.new("Role Competence", "Role Competence", ["role_competence_went_well", "role_competence_to_be_improved"],
                                                "<p> <b>Understanding:</b> Tech stack, domain, trust to onboard others <br />" +
                                                "<b>Ownership of concept:</b> go-to person for specific questions, accountability, leads discussions, confidence<br />" +
                                                "<b>Learnings:</b> Eager to learn new tools/apps/languages, ability to apply learnings, innovative, side projects, self directed learnings<br />" +
                                                "<b>Effective collaborator:</b> Good knowledge transfer, effective pair, knows shortcut keys, drives/navagates/rotates pairs, desk checks<br /></p>",
                                                "role_competence_scale")
    questions["Consulting Skills"] = Question.new("Consulting Skills", "Consulting Skills", ["consulting_skills_went_well", "consulting_skills_to_be_improved"],
                                                  "<p><b>Customer Commitment:</b> understand what the client really needs, understand deadlines and why they are important, building relationships with the client, being able to influence client de    velopers to use technologies<br />" +
                                                  "<b>Communication skils:</b> Asks questions, professionally offers concerns and alternative solutions, ability to influence, push back when needed<br />" +
                                                  "<b>Delivery:</b> Stretches to deliver if need be, understands need to deliver on time<br />" +
                                                  "<b>Aware of Perceptions:</b> professional client facing presence, good understanding of business needs vs. personal wants<br /></p>",
                                                  "consulting_skills_scale")

    questions["Teamwork"] = Question.new("Teamwork", "Teamwork", ["teamwork_went_well", "teamwork_to_be_improved"],
                                         "<p><b>Relationship building:</b> Working with team members, conflict resolution, people want to work with you again<br />" +
                                         "<b>Feedback:</b> Ability to deliver and ask for feedback, reacts well to feedback<br />" +
                                         "<b>Attitude:</b> Approachable, enthusiastic, helpful, respectful, will work outside of 40 hours to help project if needed<br />" +
                                         "<b>Professionalism:</b> Professional client-facing presence, punctual, turns in time sheets, acceptable attendance and visability to team<br /></p>",
                                         "teamwork_scale")

    questions["Contributions"] = Question.new("Contributions", "Contributions", ["contributions_went_well", "contributions_to_be_improved"],
                                              "<p><b>Knowledge Sharing:</b> L&Ls, HOD, Away Day, JC Continuing Learning Sessions, hallway chats<br />" +
                                              "<b>Social Resposibility:</b> Awareness, involvement, contribution<br />" +
                                              "<b>TW sponsored events: ex:</b> SIP, Black Girls Code, Rails Girls, Black @ TW, WNB<br /></p>",
                                              "contributions_scale")

    # BOTH
    questions["Comments"] = Question.new("Comments", "General Comments", ["comments"],
                                         "<p>Anything not covered above</p>")
    questions
  end

  # these MUST match keys in the questions block above
  def headings
    # NOTE: "Comments" is shared between both sets
    if self.new_review_format
      ["Role Competence","Consulting Skills","Teamwork", "Contributions", "Comments"]
    else
      ["Tech","Client", "Ownership", "Leadership", "OldTeamwork", "Attitude", "Professionalism", "Organizational", "Innovative", "Comments"]
    end
  end

  def heading_title(heading)
    return questions[heading].title unless questions[heading].nil?
  end

  def description(heading)
    result = ""
    unless questions[heading].nil?
      if heading != "Comments"
       result += "<p>Here are some topics to think about... </p>"
      end
      result += questions[heading].description
    end
    result
  end

  def fields_for_heading(heading)
    return questions[heading].fields unless questions[heading].nil?
    return [] # default fall-through
  end

  def has_scale(heading)
    !scale_field(heading).nil?
  end

  def scale_field(heading)
    return questions[heading].scale_field unless questions[heading].nil?
    nil
  end

  def to_s
    "#{junior_consultant.user.name} - #{review_type}"
  end

  def has_existing_feedbacks?
    feedbacks.size > 0
  end
end
