  require 'bcrypt'
  require 'faker'

  #############################
  # create test users
  #############################

  admin = User.create(name: "admin admin", okta_name: "admin", email: "admin@example.com" )
  admin.admin = true
  admin.save!

  99.times do
    first_name = Faker::Name.first_name
    User.create(name: "#{first_name} #{Faker::Name.last_name}", okta_name: first_name, email: "#{first_name.downcase}@example.com" )
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

  users = [sally, bob, nikki, luke, doug, elvis, george, johanna, gina, mandy, carrie, john, jennifer, al]



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
    AssociateConsultant.create({user_id: i, reviewing_group_id: groups.sample.id, coach_id: users.sample.id})
  end

  sallyAC = AssociateConsultant.find(1)
  bobAC = AssociateConsultant.find(2)
  johannaAC = AssociateConsultant.find(3)
  ginaAC = AssociateConsultant.find(4)
  mandyAC = AssociateConsultant.find(5)

  #############################
  # create empty reviews
  #############################

  (6..85).to_a.each do |i|
    first_review_date = 1.month.ago
    Review.create({associate_consultant_id: i, review_type: "6-Month", feedback_deadline: first_review_date, review_date: first_review_date})
    Review.create({associate_consultant_id: i, review_type: "12-Month", feedback_deadline: first_review_date + 6.months, review_date: first_review_date + 6.months})
    Review.create({associate_consultant_id: i, review_type: "18-Month", feedback_deadline: first_review_date + 12.months, review_date: first_review_date + 12.months})
    Review.create({associate_consultant_id: i, review_type: "24-Month", feedback_deadline: first_review_date + 18.months, review_date: first_review_date + 18.months})
  end


  #############################
  # Sally Review #1
  #############################

  reviewSally = Review.create({associate_consultant_id: sallyAC.id, review_type: "6-Month", feedback_deadline: 1.month.from_now, review_date: 1.month.from_now})

  reviewSally.feedbacks.create({user_id: john.id, attitude_exceeded: Faker::Lorem.sentences,
                                client_met: Faker::Lorem.sentences,
                                innovative_met: Faker::Lorem.sentences, submitted: true})
  reviewSally.feedbacks.create({user_id: nikki.id, attitude_met: Faker::Lorem.sentences,
                                client_improve: Faker::Lorem.sentences,
                                innovative_improve: Faker::Lorem.sentences,
                                comments: Faker::Lorem.sentence, submitted: true})
  reviewSally.feedbacks.create({user_id: doug.id, attitude_met: Faker::Lorem.sentences,
                                 comments: Faker::Lorem.sentence, submitted: true})
  reviewSally.feedbacks.create({user_id: george.id, attitude_met: Faker::Lorem.sentences,
                                comments: Faker::Lorem.sentence})
  reviewSally.feedbacks.create({user_id: bob.id, attitude_met: Faker::Lorem.sentences,
                                comments: Faker::Lorem.sentence})

  doug_invitation_from_sally = reviewSally.invitations.create({email: doug.email})
  elvis_invitation_from_sally = reviewSally.invitations.create({email: elvis.email})
  george_invitation_from_sally = reviewSally.invitations.create({email: george.email})

  #############################
  # Sally Review #2
  #############################
  reviewSally2 = Review.create({associate_consultant_id: sallyAC.id, review_type: "12-Month", feedback_deadline: 1.month.from_now, review_date: 1.month.from_now})

  reviewSally2.feedbacks.create({user_id: john.id, leadership_met: Faker::Lorem.sentences,
                                professionalism_exceeded: Faker::Lorem.sentences,
                                organizational_improve: Faker::Lorem.sentences, submitted: true})
  reviewSally2.feedbacks.create({user_id: nikki.id, role_competence_went_well: Faker::Lorem.sentences,
                                contributions_went_well: Faker::Lorem.sentences,
                                teamwork_to_be_improved: Faker::Lorem.sentences,
                                comments: Faker::Lorem.sentence, submitted: true})

  reviewSally2.feedbacks.create({user_id: doug.id, innovative_exceeded: Faker::Lorem.sentences,
                                 comments: Faker::Lorem.sentence, submitted: true})
  reviewSally2.feedbacks.create({user_id: george.id, attitude_improve: Faker::Lorem.sentences,
                                comments: Faker::Lorem.sentence})
  reviewSally2.feedbacks.create({user_id: bob.id, professionalism_met: Faker::Lorem.sentences,
                                comments: Faker::Lorem.sentence})

  doug_invitation_from_sally2 = reviewSally2.invitations.create({email: doug.email})
  elvis_invitation_from_sally2 = reviewSally2.invitations.create({email: elvis.email})
  george_invitation_from_sally2 = reviewSally2.invitations.create({email: george.email})

  #############################
  # Sally Review #3
  #############################

  reviewSally3 = Review.create({associate_consultant_id: sallyAC.id, review_type: "18-Month", feedback_deadline: 1.month.from_now, review_date: 1.month.from_now})

  reviewSally3.feedbacks.create({user_id: john.id, client_exceeded: Faker::Lorem.sentences,
                                innovative_exceeded: Faker::Lorem.sentences,
                                leadership_exceeded: Faker::Lorem.sentences, submitted: true})
  reviewSally3.feedbacks.create({user_id: nikki.id, role_competence_to_be_improved: Faker::Lorem.sentences,
                                teamwork_went_well: Faker::Lorem.sentences,
                                contributions_to_be_improved: Faker::Lorem.sentences,
                                comments: Faker::Lorem.sentence, submitted: true})
  reviewSally3.feedbacks.create({user_id: doug.id, leadership_improve: Faker::Lorem.sentences,
                                 comments: Faker::Lorem.sentence, submitted: true})
  reviewSally3.feedbacks.create({user_id: george.id, organizational_met: Faker::Lorem.sentences,
                                comments: Faker::Lorem.sentence})
  reviewSally3.feedbacks.create({user_id: bob.id, organizational_exceeded: Faker::Lorem.sentences,
                                comments: Faker::Lorem.sentence})

  doug_invitation_from_sally3 = reviewSally3.invitations.create({email: doug.email})
  elvis_invitation_from_sally3 = reviewSally3.invitations.create({email: elvis.email})
  george_invitation_from_sally3 = reviewSally3.invitations.create({email: george.email})

  #############################
  # Sally Review #4
  #############################

  reviewSally4 = Review.create({associate_consultant_id: sallyAC.id, review_type: "24-Month", feedback_deadline: 1.month.from_now, review_date: 1.month.from_now})

  reviewSally4.feedbacks.create({user_id: john.id, professionalism_improve: Faker::Lorem.sentences,
                                attitude_improve: Faker::Lorem.sentences,
                                client_exceeded: Faker::Lorem.sentences, submitted: true})
  reviewSally4.feedbacks.create({user_id: nikki.id, role_competence_went_well: Faker::Lorem.sentences,
                                contributions_went_well: Faker::Lorem.sentences,
                                teamwork_to_be_improved: Faker::Lorem.sentences,
                                comments: Faker::Lorem.sentence, submitted: true})

  reviewSally4.feedbacks.create({user_id: doug.id, innovative_exceeded: Faker::Lorem.sentences,
                                 comments: Faker::Lorem.sentence, submitted: true})
  reviewSally4.feedbacks.create({user_id: george.id, attitude_improve: Faker::Lorem.sentences,
                                comments: Faker::Lorem.sentence})
  reviewSally4.feedbacks.create({user_id: bob.id, professionalism_met: Faker::Lorem.sentences,
                                comments: Faker::Lorem.sentence})

  doug_invitation_from_sally4 = reviewSally4.invitations.create({email: doug.email})
  elvis_invitation_from_sally4 = reviewSally4.invitations.create({email: elvis.email})
  george_invitation_from_sally4 = reviewSally4.invitations.create({email: george.email})

  ##############################
  # create more reviews
  ##############################

  Review.create({associate_consultant_id: johannaAC.id, review_type: "6-Month", feedback_deadline: 1.week.from_now, review_date: 1.week.from_now})
  Review.create({associate_consultant_id: johannaAC.id, review_type: "12-Month", feedback_deadline: 6.months.from_now, review_date: 6.months.from_now})
  Review.create({associate_consultant_id: johannaAC.id, review_type: "18-Month", feedback_deadline: 12.months.from_now, review_date: 12.months.from_now})
  Review.create({associate_consultant_id: johannaAC.id, review_type: "24-Month", feedback_deadline: 18.months.from_now, review_date: 18.months.from_now})
  Review.create({associate_consultant_id: mandyAC.id, review_type: "6-Month", feedback_deadline: 1.week.from_now, review_date: 1.week.from_now})
  Review.create({associate_consultant_id: mandyAC.id, review_type: "12-Month", feedback_deadline: 6.months.from_now, review_date: 6.months.from_now})
  Review.create({associate_consultant_id: mandyAC.id, review_type: "18-Month", feedback_deadline: 12.months.from_now, review_date: 12.months.from_now})
  Review.create({associate_consultant_id: mandyAC.id, review_type: "24-Month", feedback_deadline: 18.months.from_now, review_date: 18.months.from_now})
  Review.create({associate_consultant_id: ginaAC.id, review_type: "6-Month", feedback_deadline: 1.week.from_now, review_date: 1.week.from_now})
  Review.create({associate_consultant_id: ginaAC.id, review_type: "12-Month", feedback_deadline: 6.months.from_now, review_date: 6.months.from_now})
