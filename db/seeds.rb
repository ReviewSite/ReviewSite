  require 'bcrypt'
  require 'faker'


  #############################
  # create test users
  #############################

  admin = User.create(name: "admin admin")
  admin.okta_name = "admin"
  admin.email = "admin@thoughtworks.com"
  admin.save!

  99.times do |n|
    first_name = Faker::Name.first_name
    user = User.create(name: "#{first_name} #{Faker::Name.last_name}")
    user.okta_name = "user#{n}"
    user.email = "user#{n}@thoughtworks.com"
    user.save!
  end

  sally = User.find(2)
  bob = User.find(3)
  nikki = User.find(4)
  luke = User.find(5)
  doug = User.find(6)
  elvis = User.find(7)
  george = User.find(8)
  johanna = User.find(9)
  gina = User.find(10)
  mandy = User.find(11)
  carrie = User.find(12)
  john = User.find(13)
  jennifer = User.find(14)
  al = User.find(15)

  @users = [sally, bob, nikki, luke, doug, elvis, george, johanna, gina, mandy, carrie, john, jennifer, al]


  #############################
  # create reviewing groups
  #############################

  chicago = ReviewingGroup.create({name: 'Chicago', users: [admin, john]})
  dallas = ReviewingGroup.create({name: 'Dallas', users: [admin, jennifer]})
  atlanta = ReviewingGroup.create({name: 'Atlanta', users: [admin, john, jennifer]})
  newyork = ReviewingGroup.create({name: 'New York', users: [admin, doug]})
  sanfran = ReviewingGroup.create({name: 'San Francisco', users: [admin, doug, carrie]})

  groups = [chicago, dallas, atlanta, newyork, sanfran]


  #############################
  # create ACs
  #############################

  (16..100).to_a.each do |i|
    associateConsultant = AssociateConsultant.create
    associateConsultant.user_id = i
    associateConsultant.reviewing_group_id = groups.sample.id
    associateConsultant.coach_id = @users.sample.id
    associateConsultant.save!
  end


  #############################
  # create reviews
  #############################

  def generate_review_with_feedbacks(id, review_type, review_date)
    review = Review.create({ associate_consultant_id: id, review_type: review_type, feedback_deadline: review_date - 3.days, review_date: review_date })

    ## create submitted feedback
    user1 = User.find(100 - id)

    review.invitations.create({ email: user1.email })

    review.feedbacks.create({ user_id: user1.id, project_worked_on: "Burkina Faso", role_competence_went_well: Faker::Lorem.sentences, consulting_skills_to_be_improved: Faker::Lorem.sentences, teamwork_went_well: Faker::Lorem.sentences,
                                submitted: true })

    ## create feedback in progress
    user2 = User.find(id)

    review.invitations.create({ email: user2.email })

    review.feedbacks.create({ user_id: user2.id, project_worked_on: "Burkina Faso", role_competence_went_well: Faker::Lorem.sentences, consulting_skills_to_be_improved: Faker::Lorem.sentences, teamwork_went_well: Faker::Lorem.sentences,
                                submitted: false })

    ## create invitations for feedback not started
    review.invitations.create({ email: @users.sample.email })
  end


  (6..85).to_a.each do |i|
    first_review_date = 1.month.ago

    generate_review_with_feedbacks(i, "6-Month", first_review_date)
    generate_review_with_feedbacks(i, "12-Month", first_review_date + 6.months)
    generate_review_with_feedbacks(i, "18-Month", first_review_date + 12.months)
    generate_review_with_feedbacks(i, "24-Month", first_review_date + 18.months)
  end
