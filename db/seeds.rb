# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# For the ReviewSite The following structures are created, or destroyed and recreated (if they already exist):
#
# JuniorConsultant User: sally@example.com
# -[[This user is designed to be your average JC user]]
# - Review: 6-Month
#  - Feeback:
#   - By: John, Submitted: true
#   - By: Nikki, Submitted: true
#   - By: Doug, Submitted: true
#   - By: George, Submitted: false
#  - Invited:
#   - Doug (has replied, submitted)
#   - Elvis (has not replied)
#   - George  (has replied, but not submitted)
# - Review: 12-Month
#  - Invited:
#   - Doug (has replied, submitted)
#
# JuniorConsultant User: bob@example.com
# - [[This user is a JC who has submitted feedback to another JC]]
# - Review: 6-Month
#  - Feedback:
#   - By: Bob, Submitted: true
#  - Self Assessment: By Bob, for Bob
# - Has provided feedback for Sally (not submitted)
#
#
# User: john@example.com
# - [[This user is a non-JC who has provided feedback, without being invited]]
#  - Has provided feedback for Sally, and Submitted it
#
# User: nikki@example.com
#  - Has provided feedback for Sally, and Submitted it
#
# User: doug@example.com
# - [[This user has been invited to provide feedback, and has submitted it]]
# - Has provided feedback for Sally TWICE
#
# User: elvis@example.com
# - [[This user has been invited to provide feedback, but hasn't]]
# - Has been invited to provide feedback
#
# User: george@example.com
# - [[This user has been invited to provide feedback, but hasn't submitted final yet]]
# - Has been invited to provide feedback
# - Has written feedback, but not finalized
#
#
# Coach User: luke@example.com
#  - Coach of Sally
#
# Admin User: admin@example.com
#
require 'bcrypt'

emails = ['john@example.com',
          'sally@example.com',
          'bob@example.com',
          'nikki@example.com',
          'luke@example.com',
          'doug@example.com',
          'elvis@example.com',
          'george@example.com',
          'jennifer@example.com',
          'admin@example.com'
]

emails.each do |existing_user|
  u = User.find_by_email(existing_user)
  unless u.nil?
    u.destroy
  end
end

chicago = ReviewingGroup.create(name: 'Chicago')

john = User.create(name: 'John', okta_name: 'john', email: 'john@example.com')
sally = User.create(name: 'sally', okta_name: 'sally', email: 'sally@example.com')
bob = User.create(name: 'bob', okta_name: 'bob', email: 'bob@example.com')
nikki = User.create(name: 'nikki', okta_name: 'nikki', email: 'nikki@example.com')
luke = User.create(name: 'luke', okta_name: 'luke', email: 'luke@example.com')
doug = User.create(name: 'doug', okta_name: 'doug', email: 'doug@example.com')
elvis = User.create(name: 'elvis', okta_name: 'elvis', email: 'elvis@example.com')
george = User.create(name: 'george', okta_name: 'george', email: 'george@example.com')

jennifer = User.new(name: 'jennifer', email: 'jennifer@example.com')
jennifer.save(validate: false)
jennifer.update_attribute(:password_digest, BCrypt::Password.create('password'))

admin = User.create(name: 'admin', okta_name: 'imadmin', email: 'admin@example.com')
admin.admin = true
admin.save!

sallyJC = JuniorConsultant.create({coach_id: luke.id, user_id: sally.id, reviewing_group_id: chicago.id})
bobJC = JuniorConsultant.create({user_id: bob.id, reviewing_group_id: chicago.id})

reviewSally = Review.create({junior_consultant_id: sallyJC.id, review_type: "6-Month", feedback_deadline: 1.month.from_now})

attitude_string = "You have a great attitude"
client_string = "You sometimes interact with the client"
innovative_string = "Your innovation is innovative in itself."
comment = "I would work with you again on a future project."

john_feedback_for_sally = Feedback.create({review_id: reviewSally.id, user_id: john.id,
                                          attitude_exceeded: attitude_string,
                                          client_met: client_string, innovative_met: innovative_string})
john_feedback_for_sally.submitted = true
john_feedback_for_sally.save!

nikki_feedback_for_sally = Feedback.create({review_id: reviewSally.id, user_id: nikki.id,
                                           attitude_met: attitude_string,
                                           client_improve: client_string, innovative_improve: innovative_string,
                                           comments: comment})
nikki_feedback_for_sally.submitted = true
nikki_feedback_for_sally.save!

doug_invitation_from_sally = reviewSally.invitations.create({email: doug.email})
elvis_invitation_from_sally = reviewSally.invitations.create({email: elvis.email})
georgeinvitation_from_sally = reviewSally.invitations.create({email: george.email})
doug_feedback_for_sally = Feedback.create({review_id: reviewSally.id, user_id: doug.id,
                                           attitude_met: attitude_string, comments: comment})
doug_feedback_for_sally.submitted = true
doug_feedback_for_sally.save!

george_feedback_for_sally = Feedback.create({review_id: reviewSally.id, user_id: george.id,
                                           attitude_met: attitude_string, comments: comment})

bob_feedback_for_sally = Feedback.create({review_id: reviewSally.id, user_id: bob.id,
                                         attitude_met: attitude_string, comments: comment})

###############
# Sally Review #2
##############
reviewSally2 = Review.create({junior_consultant_id: sallyJC.id, review_type: "12-Month", feedback_deadline: 5.months.from_now})
doug_invitation_from_sally2 =  reviewSally2.invitations.create({email: doug.email})
doug_feedback_for_sally2 = Feedback.create({review_id: reviewSally2.id, user_id: doug.id,
                                           attitude_met: "Yes. Good Attitude", comments: comment})
doug_feedback_for_sally2.submitted = true
doug_feedback_for_sally2.save!


###############
#
##############
reviewBob = Review.create({junior_consultant_id: bobJC.id, review_type: "6-Month", feedback_deadline: 1.week.from_now})
john_feedback_for_bob = Feedback.create({review_id: reviewBob.id, user_id: john.id, user_string: "John",
                                        comments: comment})
john_feedback_for_bob.submitted = true
john_feedback_for_bob.save!

bob_self_assessment = SelfAssessment.create!({review_id: reviewBob.id, junior_consultant_id: bobJC.id,
                                            response: "I think that I am a swell JC."})
