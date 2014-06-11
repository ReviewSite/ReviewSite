require 'spec_helper'

describe "Home page" do
  let (:admin) { FactoryGirl.create :admin_user }
  let (:coach) { FactoryGirl.create :user }
  let (:reviewer) { FactoryGirl.create :user }
  let (:jc_user) { FactoryGirl.create :user}
  let! (:jc) { FactoryGirl.create :junior_consultant, coach: coach, :user => jc_user }
  let! (:review) { FactoryGirl.create :review, junior_consultant: jc, feedback_deadline: Date.tomorrow }
  let! (:feedback) { FactoryGirl.create :feedback, review: review, user: reviewer, project_worked_on: "Test"}

  subject { page }

  describe "new review button" do
    it "is visible to admins" do
      sign_in admin
      click_link "New Review"
      current_path.should == new_review_path
    end

    it "is invisible to other users" do
      page.should_not have_link("New Review")
      sign_in FactoryGirl.create(:user)
      page.should_not have_link("New Review")
    end
  end

  describe "reviews table" do
    describe "as admin" do
      before { sign_in admin }

      describe "supports ajax pagination", :js => true do

        it {should have_selector("#reviews td", text: jc.reviewing_group.name) }
        it {should have_selector("table#reviews td", text: jc.user.name) }
        it {should have_selector("table#reviews td", text: review.review_type) }
        it {should have_selector("table#reviews td", text: review.review_date.to_s) }
        it {should have_selector("table#reviews td", text: review.feedback_deadline.to_s) }
        it {should have_selector("table#reviews td", text: "0 / 1") }

        it "updates submitted feedback count" do
          feedback.update_attribute(:submitted, true)
          visit root_path
          subject.should have_selector("table#reviews td", text: "1 / 1")
        end

        it "links to review summary page" do
          within("table#reviews") do
            click_link 'Feedback Summary'
          end
          current_path.should == summary_review_path(review)
        end

        it "links to review show page" do
          within("table#reviews") do
            click_link 'Show Details'
          end
          current_path.should == review_path(review)
        end

      end
    end

    describe "as JC" do
      before do
        @jc_with_many_reviews = FactoryGirl.create(:junior_consultant)
        @first_review = FactoryGirl.create(:new_review_type, :junior_consultant => @jc_with_many_reviews, :review_type => "12-Month", :review_date => Date.today - 6.months)
        @upcoming_review = FactoryGirl.create(:new_review_type, :junior_consultant => @jc_with_many_reviews, :review_type => "18-Month", :review_date => Date.today)
        @latest_review = FactoryGirl.create(:new_review_type, :junior_consultant => @jc_with_many_reviews, :review_type => "24-Month", :review_date => Date.today + 6.months)
        @feedback = FactoryGirl.create(:feedback, review: @upcoming_review, user: reviewer, project_worked_on: "Test")

        sign_in @jc_with_many_reviews.user
      end

      it { should_not have_selector("a", text: "Show") }

      it "links to reviewer invitation page" do
        click_link 'Invite Reviewer'
        current_path.should == new_review_invitation_path(@upcoming_review)
      end

      it "links to review summary page" do
        click_link 'View Summary'
        current_path.should == summary_review_path(@upcoming_review)
      end

      it "shows the name of the reviewer of additional feedback when it is not the same as the user" do
        @feedback.update_attribute(:submitted, true)
        @feedback.update_attribute(:user_string, "Additional Feedback Reviewer")
        visit root_path
        subject.should have_selector("table.feedback td", text: @feedback.user_string)
      end

      it "should only show the most recent review" do
        @jc_with_many_reviews.reviews.count.should eq(3)
        page.should have_selector("h2", text: @upcoming_review.review_type.titleize)
        page.should_not have_selector("h2", text: @latest_review.review_type.titleize)
        page.should_not have_selector("h2", text: @first_review.review_type.titleize)
      end

    end

    describe "as a coach" do
      before { sign_in coach }

      it { should_not have_selector("a", text: "Show") }

      it "links to reviewer invitation page" do
        click_link 'Request Feedback'
        current_path.should == new_review_invitation_path(review)
      end

      it "links to review summary page" do
        click_link 'View Summary'
        current_path.should == summary_review_path(review)
      end
    end
  end

  describe "feedback in-progress form" do
    let(:invited_user) { FactoryGirl.create(:user) }
    let!(:invitation) { review.invitations.create(email: invited_user.email) }

    describe "with no invitations and no drafts" do
      describe "as normal user" do
        before do
          sign_in FactoryGirl.create(:user)
          visit root_path
        end

        it "should not display invitations table" do
          page.should_not have_selector('h2', text: 'Provide feedback for')
          page.should_not have_selector('table.unfinished_feedbacks')
        end
      end
    end

    describe "with draft feedback but no invitation" do
      let(:user) { FactoryGirl.create(:user) }
      let(:feedback) { FactoryGirl.create(:feedback, review: review, user: user) }

      describe "as a normal user" do
        before do
          sign_in user
        end

        it "should display table with feedback details" do
          visit root_path
          page.should have_selector('table.unfinished_feedbacks td', text: jc.user.name)
          page.should have_selector('table.unfinished_feedbacks td', text: review.review_type)
          page.should have_selector('table.unfinished_feedbacks td', text: review.feedback_deadline.to_s)
          page.should have_selector('table.unfinished_feedbacks td', text: "Not Submitted")

          within('.unfinished_feedbacks') { click_link "Continue" }
          current_path.should == edit_review_feedback_path(review, feedback)
        end

        it "should not appear if feedback has been submitted" do
          feedback.update_attribute(:submitted, true)
          visit root_path
          page.should_not have_selector('table.unfinished_feedbacks')
        end
      end
    end

    describe "with a current invitation" do
      before do
        sign_in invited_user
      end

      it "should have 'Create' action and 'Not Started' status if feedback is not started" do
        visit root_path
        page.should have_selector('h2', text: 'Provide Feedback For')
        page.should have_selector('table.unfinished_feedbacks td', text: jc.user.name)
        page.should have_selector('table.unfinished_feedbacks td', text: review.review_type)
        page.should have_selector('td.invitation_date', text: invitation.sent_date.to_s)
        page.should have_selector('td.feedback_deadline', text: review.feedback_deadline.to_s)
        page.should have_selector('table.unfinished_feedbacks td', text: "Not Started")
        page.should have_selector('table.unfinished_feedbacks td a', text: "Create")
        within('.unfinished_feedbacks') { click_link "Create" }
        current_path.should == new_review_feedback_path(review)
      end

      it "should have 'Continue' action and 'Not Submitted' status if feedback has been saved but not submitted" do
        FactoryGirl.create(:feedback, review: review, user: invited_user)

        visit root_path
        page.should have_selector('h2', text: 'Provide Feedback For')
        page.should have_selector('table.unfinished_feedbacks td', text: jc.user.name)
        page.should have_selector('table.unfinished_feedbacks td', text: review.review_type)
        page.should have_selector('td.invitation_date', text: invitation.sent_date.to_s)
        page.should have_selector('td.feedback_deadline', text: review.feedback_deadline.to_s)
        page.should have_selector('table.unfinished_feedbacks td', text: "Not Submitted")
        page.should have_selector('table.unfinished_feedbacks td a', text: "Continue")
        within('.unfinished_feedbacks') { click_link "Continue" }
        current_path.should == edit_review_feedback_path(review, invitation.feedback)
      end

      it "should not appear if feedback has been submitted" do
        FactoryGirl.create(:submitted_feedback, review: review, user: invited_user)

        visit root_path
        page.should_not have_selector('table.unfinished_feedbacks')
      end
    end
  end
end
