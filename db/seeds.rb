# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
john = User.create({name: 'John', email: 'john@example.com', 
                   password: 'password123', password_confirmation: 'password123'})
sally = User.create({name: 'sally', email: 'sally@example.com', 
                   password: 'password123', password_confirmation: 'password123'})
bob = User.create({name: 'bob', email: 'bob@example.com', 
                   password: 'password123', password_confirmation: 'password123'})
nikki = User.create({name: 'nikki', email: 'nikki@example.com', 
                   password: 'password123', password_confirmation: 'password123'})
luke = User.create({name: 'luke', email: 'luke@example.com', 
                   password: 'password123', password_confirmation: 'password123'})

admin = User.create({name: 'admin', email: 'admin@example.com', password: 'password123',
                    password_confirmation: 'password123'})
admin.admin = true
admin.save!

sallyJC = JuniorConsultant.create({name: 'sally', email: 'sally@example.com', coach_id: luke.id})
bobJC = JuniorConsultant.create({name: 'bob', email: 'bob@example.com'})

reviewSally = Review.create({junior_consultant_id: sallyJC.id, review_type: "6-Month"})
reviewBob = Review.create({junior_consultant_id: bobJC.id, review_type: "6-Month"})

attitude_string = "You have a great attitude"
client_string = "You sometimes interact with the client"
innovative_string = "Your innovation is innovative in itself."
comment = "I would work with you again on a future project."

john_feedback_for_sally = Feedback.create({review_id: reviewSally.id, user_id: john.id, 
                                          user_string: 'John', attitude_exceeded: attitude_string,
                                          client_met: client_string, innovative_met: innovative_string})
john_feedback_for_sally.submitted = true
john_feedback_for_sally.save!

nikki_feedback_for_sally = Feedback.create({review_id: reviewSally.id, user_id: nikki.id,
                                           user_string: "Nikki", attitude_met: attitude_string,
                                           client_improve: client_string, innovative_improve: innovative_string,
                                           comments: comment})
nikki_feedback_for_sally.submitted = true
nikki_feedback_for_sally.save!

john_feedback_for_bob = Feedback.create({review_id: reviewBob.id, user_id: john.id, user_string: "John",
                                        comments: comment})
john_feedback_for_bob.submitted = true
john_feedback_for_bob.save!

bob_self_assessment = SelfAssessment.create({review_id: reviewBob.id, junior_consultant_id: bob.id,
                                            response: "I think that I am a swell JC."})
