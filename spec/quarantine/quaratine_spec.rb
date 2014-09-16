# THIS IS THE TEST QUARANTINE
# Tests in this file are FLAKY. They should be resolved before they are moved
# out of this file. Tests must be resolved as soon as there are 10 tests in
# this file, or if two weeks have passed since the tests were quarantined,
# whichever comes first.

# Last updated: August 6, 2014

# require 'spec_helper'



# FEEDBACK_PAGES_SPEC

# describe "Feedback pages", :type => :feature do
#   let(:ac_user) { FactoryGirl.create(:user) }
#   let(:ac) { FactoryGirl.create(:associate_consultant, :user => ac_user) }
#   let(:user) { FactoryGirl.create(:user) }
#   let(:admin) { FactoryGirl.create(:admin_user) }
#   let(:review) { FactoryGirl.create(:review, associate_consultant: ac) }
#   let(:inputs) { {
#     'feedback_comments' => 'My Comments'
#   } }

#   subject { page }

#   describe "new", :type => :feature do
#     before do
#       sign_in user
#     end

#     describe "if no existing feedback", js: true, :type => :feature do
#       before do
#         visit new_review_feedback_path(review)

#         page.find('h3', :text => 'Comments').click

#         inputs.each do |field, value|
#           fill_in field, with: value
#         end
#       end

#       # it "saves as draft if 'Save Feedback' is clicked" do
#       #   first(:button, "Save Feedback").click
#       #   find(".alert") #wait for the resulting page to load

#       #   feedback = Feedback.last
#       #   current_path.should == edit_review_feedback_path(review, feedback)
#       #   feedback.submitted.should be_false

#       #   inputs.each do |field, value|
#       #     model_attr = field[9..-1]
#       #     feedback.send(model_attr).should == value
#       #   end
#       # end

#       # it "saves as final and sends email if 'Submit Final' is clicked", js: true do
#       #   ActionMailer::Base.deliveries.clear

        #   page.evaluate_script('window.confirm = function() { return true; }')
#       #   click_button "Submit Final"
#       #   find(".alert-notice") # wait for the resulting page to load

#       #   feedback = Feedback.last
#       #   current_path.should == review_feedback_path(review, feedback)
#       #   feedback.submitted.should be_true

#       #   inputs.each do |field, value|
#       #     model_attr = field[9..-1]
#       #     feedback.send(model_attr).should == value
#       #   end

#       #   ActionMailer::Base.deliveries.length.should == 1
#       #   mail = ActionMailer::Base.deliveries.last
#       #   mail.to.should == [ac.user.email]
#       #   mail.subject.should == "[ReviewSite] You have new feedback from #{feedback.user}"
#       # end

#     end

#   end

#   describe "edit" do
#     let(:feedback) { FactoryGirl.create(:feedback, review: review, user: user) }

#     describe "if feedback has been saved as draft" do
#       before do
#         inputs.each do |field, value|
#           model_attr = field[9..-1]
#           feedback.update_attribute(model_attr, value)
#         end
#         visit edit_review_feedback_path(review, feedback)
#       end

#       # it "saves as final if 'Submit Final' is clicked", js: true do
#       #   ActionMailer::Base.deliveries.clear

#       #   page.find('h3', :text => 'Comments').click

#       #   inputs.each do |field, value|
#       #     fill_in field, with: ""
#       #   end

#       #   page.evaluate_script('window.confirm = function() { return true; }')
#       #   click_button "Submit Final"
#       #   find(".alert-notice") # wait for the resulting page to load

#       #   feedback = Feedback.last
#       #   current_path.should == review_feedback_path(review, feedback)
#       #   feedback.submitted.should be_true

#       #   inputs.each do |field, value|
#       #     model_attr = field[9..-1]
#       #     feedback.send(model_attr).should == ""
#       #   end

#       #   ActionMailer::Base.deliveries.length.should == 1
#       #   mail = ActionMailer::Base.deliveries.last
#       #   mail.to.should == [ac.user.email]
#       #   mail.subject.should == "[ReviewSite] You have new feedback from #{feedback.user}"
#       # end
#     end

#   end

#   describe "additional" do
#     before do
#       sign_in FactoryGirl.create(:user)
#       visit additional_review_feedbacks_path(review)
#       fill_in "feedback_user_string", with: "A non-user"

#       page.find('h3', :text => 'Comments').click

#       inputs.each do |field, value|
#         fill_in field, with: value
#       end
#     end

#     it "saves as final and sends email if 'Submit Final' is clicked", js: true do
#       ActionMailer::Base.deliveries.clear

#       page.evaluate_script('window.confirm = function() { return true; }')
#       click_button "Submit Final"
#       find(".alert-notice") # wait for the resulting page to load

#       feedback = Feedback.last
#       current_path.should == review_feedback_path(review, feedback)
#       feedback.submitted.should be_true
#       feedback.user_string.should == "A non-user"
#       inputs.each do |field, value|
#         model_attr = field[9..-1]
#         feedback.send(model_attr).should == value
#       end

#       ActionMailer::Base.deliveries.length.should == 1
#       mail = ActionMailer::Base.deliveries.last
#       mail.to.should == [ac.user.email]
#       mail.subject.should == "[ReviewSite] You have new feedback from #{feedback.user}"
#     end
#   end

# end



# REVIEW_PAGES_SPEC

# describe "Review pages" do
#   let(:admin) { FactoryGirl.create(:admin_user) }
#   let(:coach) { FactoryGirl.create(:user) }
#   let(:reviewer) { FactoryGirl.create(:user) }
#   let(:ac_user) { FactoryGirl.create(:user) }
#   let(:ac) { FactoryGirl.create(:associate_consultant, coach: coach, :user => ac_user) }
#   let!(:review) { FactoryGirl.create(:review, associate_consultant: ac) }

#   subject { page }

#   describe "new" do
#     describe "as an admin" do
#       before do
#         sign_in admin
#         visit new_review_path
#       end

#       it "creates a new review" do
#         fill_in 'review_associate_consultant_id', with: ac.id
#         select "24-Month", from: "Review type"

#         fill_in "review_review_date", with: "07/01/2014"
#         fill_in "review_feedback_deadline", with: "21/06/2014"
#         fill_in "review_send_link_date", with: "04/01/2014"

#         click_button "Create Review"

#         new_review = Review.last
#         new_review.reload
#         current_path.should == review_path(new_review)
#         new_review.associate_consultant.should == ac
#         new_review.review_type.should == "24-Month"
#         new_review.review_date.should == Date.new(2014, 1, 7)
#         new_review.feedback_deadline.should == Date.new(2014, 06, 21)
#         new_review.send_link_date.should == Date.new(2014, 1, 4)
#       end
#     end
#   end

# end
