class Review < ActiveRecord::Base
  include ModelsModule
  attr_accessible \
      :associate_consultant_id,
      :feedback_deadline,
      :review_date,
      :review_type

  belongs_to :associate_consultant

  validates :review_type, :presence => true,
            :inclusion => { :in => %w(6-Month 12-Month 18-Month 24-Month) }
  validates :associate_consultant_id, :presence => true
  validates :associate_consultant_id, :uniqueness => {:scope => [:review_type]}
  validates :feedback_deadline, :presence => true
  validates :review_date, :presence => true

  has_many :feedbacks, :dependent => :destroy
  has_many :self_assessments, :dependent => :destroy
  has_many :invitations, :dependent => :destroy
  after_validation :check_errors


  def self.default_load
    self.includes({ :associate_consultant => :user })
  end

  after_initialize :init

  def init
    self.new_review_format = true if new_record?
  end

  def self.create_default_reviews(ac)
    reviews = []
    (6..24).step(6) do |n|
      review = Review.create({associate_consultant_id: ac.id,
      review_type: n.to_s + "-Month",
      review_date: ac.program_start_date + n.months,
      feedback_deadline: ac.program_start_date + n.months - 7.days})
      reviews << review
    end
    return reviews
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

    # new-style questions
    questions["Role Competence"] = Question.new("Role Competence", " Role Competence", ["role_competence_went_well", "role_competence_to_be_improved"],
                    "<p class = \'ideaList\'> \
                      <div class = \'ideaListHeader\'><b> Understanding:</b> Does #{associate_consultant} </div>\
                      <ul class = \'ideaListElement\'>\
                        <li> understand the tech stack and the business domain? </li>\
                        <li> have sufficient knowledge to help onboard new team members? </li></ul>\

                      <div class = \'ideaListHeader\'><b> Ownership of Concepts:</b> Does #{associate_consultant} </div>\
                      <ul class = \'ideaListElement\'>\
                        <li> act as a go-to person for a specific topic? </li>\ 
                        <li> take leadership in situations related to their specialities? </li>\ 
                        <li> teach others? </li></ul>\

                      <div class = \'ideaListHeader\'><b> Self Directed Learning:</b> Does #{associate_consultant} </div>\
                      <ul class = \'ideaListElement\'>\
                        <li> study project-related topics outside of work? </li>\
                        <li> apply lessons learned through studies to the project? </li>\
                        <li> look for and suggest new ways to improve the project? </li></ul>\
                    </p>", "role_competence_scale")

    questions["Consulting Skills"] = Question.new("Consulting Skills", " Consulting Skills", ["consulting_skills_went_well", "consulting_skills_to_be_improved"],
                    "<p class = \'ideaList\'> \
                      <div class = \'ideaListHeader\'><b> Client Relationships:</b> Does #{associate_consultant} </div>\
                      <ul class = \'ideaListElement\'>\
                        <li> understand the clients\' needs and deadlines? </li>\
                        <li> actively build relationships? </li>\
                        <li> push back when necessary and provide constructive reasons? </li></ul>\

                      <div class = \'ideaListHeader\'><b> Communication Skills\:</b> Does #{associate_consultant} </div>\
                      <ul class = \'ideaListElement\'>\
                        <li> ask questions and actively listen? </li>\
                        <li> deliver focused and effective discussions? </li>\
                        <li> offer concerns and alternative solutions? </li></ul>\

                      <div class = \'ideaListHeader\'><b> Professionalism:</b> Does #{associate_consultant} </div>\
                      <ul class = \'ideaListElement\'>\
                        <li> demonstrate accountability for assigned tasks and responsibilities? </li>\
                        <li> show up on time and work necessary hours? </li>\
                        <li> behave appropriately in work environments? </li>\
                        <li> follow through on commitments? </li>\
                        <li> show awareness of others\' perceptions? </li></ul>\
                    </p>", "consulting_skills_scale")

    questions["Teamwork"] = Question.new("Teamwork", " Teamwork", ["teamwork_went_well", "teamwork_to_be_improved"],
                    "<p class = \'ideaList\'>\
                      <div class = \'ideaListHeader\'><b> Attitude:</b> Does #{associate_consultant} </div>\
                      <ul class = \'ideaListElement\'>\
                        <li> show enthusiasm for the project? </li>\
                        <li> focus on helping the team succeed rather than having their own \'hero moments\'? </li></ul>\
                      
                      <div class = \'ideaListHeader\'><b> Collaboration:</b> Does #{associate_consultant} </div>\
                      <ul class = \'ideaListElement\'>\
                        <li> communicate effectively and respectfully to their pair? </li>\
                        <li> facilitate cross-role communication? </li>\
                        <li> resolve conflicts within the team? </li>\
                        <li> give and receive feedback well? </li></ul>\
                    </p>", "teamwork_scale")

    questions["Contributions"] = Question.new("Contributions", " Contributions", ["contributions_went_well", "contributions_to_be_improved"],
                    "<p class = \'ideaList\'>\
                      <div class = \'ideaListHeader\'><b> Knowledge Sharing:</b> Does #{associate_consultant} </div>\
                      <ul class = \'ideaListElement\'>\
                        <li> give presentations or lead discussions? </li>\
                        <li> reach out and offer support to other ThoughtWorkers? </li></ul>\

                      <div class = \'ideaListHeader\'><b> Social Responsibility:</b> Does #{associate_consultant} </div>\
                      <ul class = \'ideaListElement\'>\
                        <li> demonstrate awareness and interest in learning more about social issues? </li>\
                        <li> participate in P3 events and discussions? </li></ul>\

                      <div class = \'ideaListHeader\'><b> Participation</b> Does #{associate_consultant} </div>\
                      <ul class = \'ideaListElement\'>
                        <li> volunteer to organize or attend events? </li>\
                        <li> actively contribute to the betterment of TW (ex: recruiting, provide feedback for AC Learning Plan)? </li></ul>\
                    </p>", "contributions_scale")

    # BOTH
    questions["Comments"] = Question.new("Comments", " General Comments", ["comments"],
                                         "<p>Anything not covered above. What else do you want to share about #{associate_consultant}?</p>")
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
       result += "<p>Here are some questions to consider... </p>"
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
    self.pretty_print_with(nil)
  end

  def pretty_print_with(user)
    if !user.nil? && user == associate_consultant.user
      "Your #{review_type} Review"
    else
      "#{associate_consultant.user.name}'s #{review_type} Review"
    end
  end

  def has_existing_feedbacks?
    feedbacks.size > 0
  end

  def upcoming?
    self.review_date.present? && self.review_date.between?(Date.today, Date.today + 6.months)
  end

  def check_errors
    update_errors(self)
  end
end
