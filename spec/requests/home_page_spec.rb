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

      it { should have_selector("table.reviews td", text: jc.user.name) }
      it { should have_selector("table.reviews td", text: review.review_type) }
      it { should have_selector("table.reviews td.feedback_submitted", text: "0 / 1") }
      it { should have_selector("table.reviews td.review_date", text: review.review_date.to_s) }
      it { should have_selector("table.reviews td.feedback_deadline", text: review.feedback_deadline.to_s) }
      it { should have_selector("table.reviews td.send_link_date", text: review.send_link_date.to_s) }


      it "links to reviewer invitation page" do
        within("table.reviews") do
          click_link 'Invite'
        end
        current_path.should == new_review_invitation_path(review)
      end

      it "updates submitted feedback count" do
        feedback.update_attribute(:submitted, true)
        visit root_path
        subject.should have_selector("table.reviews td.feedback_submitted", text: "1 / 1")
      end

      it "links to review summary page" do
        within("table.reviews") do
          click_link 'Summary'
        end
        current_path.should == summary_review_path(review)
      end

      it "links to review show page" do
        within("table.reviews") do
          click_link 'Show'
        end
        current_path.should == review_path(review)
      end
    end

    describe "as JC" do
      before { sign_in jc_user }

      it { should_not have_selector("a", text: "Show") }

      it "links to reviewer invitation page" do
        click_link 'Invite Reviewer'
        current_path.should == new_review_invitation_path(review)
      end

      it "links to review summary page" do
        click_link 'View Summary'
        current_path.should == summary_review_path(review)
      end

      it "shows the name of the reviewer of additional feedback when it is not the same as the user" do
        feedback.update_attribute(:submitted, true)
        feedback.update_attribute(:user_string, "Additional Feedback Reviewer")
        visit root_path
        subject.should have_selector("table.feedback td", text: feedback.user_string)
      end
    end

    describe "as a coach" do
      before { sign_in coach }

      it { should_not have_selector("a", text: "Show") }

      it "links to reviewer invitation page" do
        click_link 'Invite Reviewer'
        current_path.should == new_review_invitation_path(review)
      end

      it "links to review summary page" do
        click_link 'View Summary'
        current_path.should == summary_review_path(review)
      end
    end
  end

  describe "feedbacks table" do
    describe "as an admin" do
      before { sign_in admin }

      it { should have_selector('th', text: 'Action') }
      it { should have_selector("table.feedback td", text: reviewer.name) }
      it { should have_selector("table.feedback td", text: jc.user.name) }
      it { should have_selector("table.feedback td", text: review.review_type) }
      it { should have_selector("table.feedback td", text: feedback.project_worked_on) }
      it { should have_selector("table.feedback td", text: feedback.updated_at.to_date.to_s) }
      it { should have_selector("table.feedback td", text: "Not Submitted") }
      it { should_not have_selector("table.feedback td a", text: "Unsubmit") }
      it { should_not have_selector("table.feedback td a", text: "Show") }
      it { should_not have_selector("table.feedback td a", text: "Edit") }

      it "submits feedback if 'Submit' is clicked" do
        within("table.feedback") do
          click_link 'Submit'
        end
        current_path.should == root_path
        page.should have_selector("div.alert.alert-notice", text: "Feedback was successfully updated.")
        feedback.reload
        feedback.submitted.should be_true
      end

      describe "with submitted feedback" do
        before do
          feedback.update_attribute(:submitted, true)
          visit root_path
        end

        it { should_not have_selector("table.feedback td", text: "Not Submitted") }
        it { should have_selector("table.feedback td", text: "Submitted") }
        it { should_not have_selector("table.feedback td a", text: "Submit") }

        it "unsubmits feedback if 'Unsubmit' is clicked" do
          within("table.feedback") do
            click_link 'Unsubmit'
          end
          current_path.should == root_path
          page.should have_selector("div.alert.alert-notice", text: "Feedback was successfully updated.")
          feedback.reload
          feedback.submitted.should be_false
        end

        it "links to show feedback page" do
          within("table.feedback") do
            click_link 'Show'
          end
          current_path.should == review_feedback_path(review, feedback)
        end

        it "links to edit feedback page" do
          within("table.feedback") do
            click_link 'Edit'
          end
          current_path.should == edit_review_feedback_path(review, feedback)
        end

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
