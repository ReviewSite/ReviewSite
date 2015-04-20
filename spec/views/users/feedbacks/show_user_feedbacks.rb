require 'spec_helper'

describe "User Feedbacks" do

	before(:each) do
		@reviewer = create(:user, name: "Walter", email: "walter@example.com")
		@dude = create(:user, name: "Jeffrey", email: "jeffrey@example.com")
		@jesus = create(:user, name: "Jesus", email: "jesus@example.com")
		@donnie = create(:user, name: "Donnie", email: "shutupdonnie@example.com")
		@ac1 = create(:associate_consultant, user: @dude)
		@ac2 = create(:associate_consultant, user: @jesus)
		@ac3 = create(:associate_consultant, user: @donnie)
		@reviewOne = create(:review, :new_review_format => false, associate_consultant: @ac1)
		@reviewTwo = create(:review, :new_review_format => false, associate_consultant: @ac2)
		@reviewThree = create(:review, :new_review_format => false, associate_consultant: @ac3)
		@invitation = create(:invitation, review: @reviewThree, email: @reviewer.email)
		@unfinished = create(:feedback, submitted: false, review: @reviewTwo, user: @reviewer)
		@completed = create(:feedback, submitted: true, review:@reviewOne, user: @reviewer)
		sign_in @reviewer
		visit feedbacks_user_path(@reviewer)
	end

	it "should have the right page elements" do
		page.should have_content(@reviewer.name)
		within(:css, "#invitations") do
			page.should have_content(@donnie.name)
			page.should have_content(@reviewThree.review_type)
		end
		within(:css, '#feedbacks') do
			page.should have_content(@jesus.name)
			page.should have_content(@reviewTwo.review_type)
		end
		within(:css, '#completeds') do
			page.should have_content(@dude.name)
			page.should have_content(@reviewOne.review_type)
		end
	end

	it "should redirect to new feedback path when 'Start Feedback' link clicked" do
		within(:css, '#invitations') do
			click_link 'Start Feedback'
			current_path.should eq new_review_feedback_path(@reviewThree)
		end
	end

	it "should redirect to edit feedback path when 'Resume Feedback' link clicked" do
		within(:css, '#feedbacks') do
			click_link 'Resume Feedback'
			current_path.should eq edit_review_feedback_path(@reviewTwo, @unfinished)
		end
	end

	it "should redirect to view feedback path when 'View Feedback' link clicked" do
		within(:css, '#completeds') do
			click_link 'View Feedback'
			current_path.should eq review_feedback_path(@reviewOne, @completed)
		end
	end

end