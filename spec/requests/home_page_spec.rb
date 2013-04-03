require 'spec_helper'

describe "Home page" do
  let (:admin) { FactoryGirl.create :admin_user }
  let (:coach) { FactoryGirl.create :user }
  let (:reviewer) { FactoryGirl.create :user }
  let! (:jc) { FactoryGirl.create :junior_consultant, coach: coach }
  let (:jc_user) { FactoryGirl.create :user, email: jc.email}
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

      it { should have_selector("table.reviews td", text: jc.name) }
      it { should have_selector("table.reviews td", text: review.review_type) }
      it { should have_selector("table.reviews td.feedback_submitted", text: '0') }
      it { should have_selector("table.reviews td.review_date", text: review.review_date.to_s) }
      it { should have_selector("table.reviews td.feedback_deadline", text: review.feedback_deadline.to_s) }
      it { should have_selector("table.reviews td.send_link_date", text: review.send_link_date.to_s) }

      it "links to new feedback page" do
        within("table.reviews") do
          click_link 'New Feedback'
        end
        current_path.should == new_review_feedback_path(review)
      end

      it "links to reviewer invitation page" do
        within("table.reviews") do
          click_link 'Invite Reviewer'
        end
        current_path.should == new_review_invitation_path(review)
      end

      it "updates submitted feedback count" do
        feedback.update_attribute(:submitted, true)
        visit root_path
        subject.should have_selector("table.reviews td.feedback_submitted", text: '1')
      end

      it "links to review summary page" do
        within("table.reviews") do
          click_link 'View Summary'
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

      it { should have_selector("table.reviews td", text: jc.name) }
      it { should have_selector("table.reviews td", text: review.review_type) }
      it { should have_selector("table.reviews td.feedback_submitted", text: '0') }
      it { should_not have_selector("table.reviews a", text: "New Feedback") }
      it { should_not have_selector("table.reviews a", text: "Show") }

      it "links to reviewer invitation page" do
        within("table.reviews") do
          click_link 'Invite Reviewer'
        end
        current_path.should == new_review_invitation_path(review)
      end

      it "updates submitted feedback count" do
        feedback.update_attribute(:submitted, true)
        visit root_path
        subject.should have_selector("table.reviews td.feedback_submitted", text: '1')
      end

      it "links to review summary page" do
        within("table.reviews") do
          click_link 'View Summary'
        end
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

      it { should have_selector("table.reviews td", text: jc.name) }
      it { should have_selector("table.reviews td", text: review.review_type) }
      it { should have_selector("table.reviews td.feedback_submitted", text: '0') }
      it { should_not have_selector("table.reviews a", text: "New Feedback") }
      it { should_not have_selector("table.reviews a", text: "Show") }

      it "links to reviewer invitation page" do
        within("table.reviews") do
          click_link 'Invite Reviewer'
        end
        current_path.should == new_review_invitation_path(review)
      end

      it "updates submitted feedback count" do
        feedback.update_attribute(:submitted, true)
        visit root_path
        subject.should have_selector("table.reviews td.feedback_submitted", text: '1')
      end

      it "links to review summary page" do
        within("table.reviews") do
          click_link 'View Summary'
        end
        current_path.should == summary_review_path(review)
      end
    end

    describe "as a user unaffiliated with a review" do
      before { sign_in FactoryGirl.create(:user) }
      it { should_not have_selector("table.reviews") }
    end
  end

  describe "feedbacks table" do
    describe "as an admin" do
      before { sign_in admin }

      it { should have_selector('th', text: 'Action') }
      it { should have_selector("table.feedback td", text: reviewer.name) }
      it { should have_selector("table.feedback td", text: jc.name) }
      it { should have_selector("table.feedback td", text: review.review_type) }
      it { should have_selector("table.feedback td", text: feedback.project_worked_on) }
      it { should have_selector("table.feedback td", text: feedback.updated_at.to_date.to_s) }
      it { should have_selector("table.feedback td", text: "Not Submitted") }
      it { should_not have_selector("table.feedback td a", text: "Unsubmit") }
      it { should_not have_selector("table.feedback td a", text: "Show") }
      it { should_not have_selector("table.feedback td a", text: "Edit") }
      it { should_not have_selector("table.feedback td a", text: "Destroy") }

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

        it "links to destroy feedback", js: true do
          within("table.feedback") do
            click_link 'Destroy'
          end
          page.evaluate_script("window.confirm = function() { return true; }")
          current_path.should == root_path
          Feedback.find_by_id(feedback).should be_nil
        end
      end
    end

    describe "as a JC" do
      before { sign_in jc_user }

      it { should_not have_selector("table.feedback") }

      describe "with submitted feedback" do
        before do
          feedback.update_attribute(:submitted, true)
          visit root_path
        end

        it { should_not have_selector('th', text: 'Action') }
        it { should have_selector("table.feedback td", text: reviewer.name) }
        it { should have_selector("table.feedback td", text: jc.name) }
        it { should have_selector("table.feedback td", text: review.review_type) }
        it { should have_selector("table.feedback td", text: feedback.project_worked_on) }
        it { should have_selector("table.feedback td", text: feedback.updated_at.to_date.to_s) }
        it { should have_selector("table.feedback td", text: "Submitted") }
        it { should_not have_selector("table.feedback td a", text: "Unsubmit") }
        it { should_not have_selector("table.feedback td a", text: "Edit") }
        it { should_not have_selector("table.feedback td a", text: "Destroy") }

        it "links to show feedback page" do
          within("table.feedback") do
            click_link 'Show'
          end
          current_path.should == review_feedback_path(review, feedback)
        end
      end
    end

    describe "as a coach" do
      before { sign_in coach }

      it { should_not have_selector("table.feedback") }

      describe "with submitted feedback" do
        before do
          feedback.update_attribute(:submitted, true)
          visit root_path
        end

        it { should_not have_selector('th', text: 'Action') }
        it { should have_selector("table.feedback td", text: reviewer.name) }
        it { should have_selector("table.feedback td", text: jc.name) }
        it { should have_selector("table.feedback td", text: review.review_type) }
        it { should have_selector("table.feedback td", text: feedback.project_worked_on) }
        it { should have_selector("table.feedback td", text: feedback.updated_at.to_date.to_s) }
        it { should have_selector("table.feedback td", text: "Submitted") }
        it { should_not have_selector("table.feedback td a", text: "Unsubmit") }
        it { should_not have_selector("table.feedback td a", text: "Edit") }
        it { should_not have_selector("table.feedback td a", text: "Destroy") }

        it "links to show feedback page" do
          within("table.feedback") do
            click_link 'Show'
          end
          current_path.should == review_feedback_path(review, feedback)
        end
      end
    end

    describe "as a reviewer" do
      before { sign_in reviewer }

      it { should_not have_selector('th', text: 'Action') }
      it { should have_selector("table.feedback td", text: reviewer.name) }
      it { should have_selector("table.feedback td", text: jc.name) }
      it { should have_selector("table.feedback td", text: review.review_type) }
      it { should have_selector("table.feedback td", text: feedback.project_worked_on) }
      it { should have_selector("table.feedback td", text: feedback.updated_at.to_date.to_s) }
      it { should have_selector("table.feedback td", text: "Not Submitted") }
      it { should_not have_selector("table.feedback td a", text: "Submit") }

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

      it "links to destroy feedback", js: true do
        within("table.feedback") do
          click_link 'Destroy'
        end
        page.evaluate_script("window.confirm = function() { return true; }")
        current_path.should == root_path
        Feedback.find_by_id(feedback).should be_nil
      end

      describe "with submitted feedback" do
        before do
          feedback.update_attribute(:submitted, true)
          visit root_path
        end

        it { should have_selector("table.feedback td", text: "Submitted") }
        it { should_not have_selector("table.feedback td a", text: "Unsubmit") }
        it { should_not have_selector("table.feedback td a", text: "Edit") }
        it { should_not have_selector("table.feedback td a", text: "Destroy") }

        it "links to show feedback page" do
          within("table.feedback") do
            click_link 'Show'
          end
          current_path.should == review_feedback_path(review, feedback)
        end
      end
    end

    describe "as a user unaffiliated with a review" do
      before { sign_in FactoryGirl.create(:user) }
      it { should_not have_selector("table.feedback") }      
    end
  end

  describe "invitations received form" do
    let(:invited_user) { FactoryGirl.create(:user) }
    let!(:invitation) { review.invitations.create(email: invited_user.email) }

    describe "with no invitations" do
      describe "as normal user" do
        before do
          sign_in FactoryGirl.create(:user)
          visit root_path
        end

        it "should not display invitations table" do
          page.should_not have_selector('h2', text: 'Provide feedback for')
          page.should_not have_selector('table.invitations_received')
        end
      end

      describe "as admin" do
        before do
          sign_in admin
          visit root_path
        end

        it "should not display invitations table" do
          page.should_not have_selector('h2', text: 'Provide feedback for')
          page.should_not have_selector('table.invitations_received')
        end
      end
    end

    describe "with a current invitation" do
      before do
        sign_in invited_user
      end

      it "should display invitations table" do
        visit root_path
        page.should have_selector('h2', text: 'Provide Feedback For')
        page.should have_selector('table.invitations_received td', text: jc.name)
        page.should have_selector('table.invitations_received td', text: review.review_type)
        page.should have_selector('table.invitations_received td', text: invitation.sent_date.to_s)
        page.should have_selector('table.invitations_received td', text: review.feedback_deadline.to_s)
      end

      it "should have 'Create' action and 'Not Started' status if feedback is not started" do
        visit root_path
        page.should have_selector('table.invitations_received td', text: "Not Started")
        page.should have_selector('table.invitations_received td a', text: "Create")
        within('.invitations_received') { click_link "Create" }
        current_path.should == new_review_feedback_path(review)
      end

      it "should have 'Continue' action and 'Not Submitted' status if feedback has been saved but not submitted" do
        FactoryGirl.create(:feedback, review: review, user: invited_user)

        visit root_path
        page.should have_selector('table.invitations_received td', text: "Not Submitted")
        page.should have_selector('table.invitations_received td a', text: "Continue")
        within('.invitations_received') { click_link "Continue" }
        current_path.should == edit_review_feedback_path(review, invitation.feedback)
      end

      it "should have 'View' action and 'Submitted' status if feedback has been submitted" do
        FactoryGirl.create(:submitted_feedback, review: review, user: invited_user)

        visit root_path
        page.should have_selector('table.invitations_received td', text: "Submitted")
        page.should_not have_selector('table.invitations_received td', text: "Not")
        page.should have_selector('table.invitations_received td a', texts: "View")
        within('.invitations_received') { click_link "View" }
        current_path.should == review_feedback_path(review, invitation.feedback)
      end
    end

    describe "with an expired invitation" do
      before do
        review.update_attribute(:feedback_deadline, Date.yesterday)
        sign_in invited_user
      end

      it "should not display invitation if feedback was submitted" do
        FactoryGirl.create(:submitted_feedback, review: review, user: invited_user)
        visit root_path
        page.should_not have_selector('h2', text: 'Provide Feedback For')
        page.should_not have_selector('table.invitations_received')
      end

      it "should display invitation if feedback was created but not submitted" do
        FactoryGirl.create(:feedback, review: review, user: invited_user)
        visit root_path
        page.should have_selector('h2', text: 'Provide Feedback For')
        page.should have_selector('table.invitations_received')
      end

      it "should display invitation if feedback hasn't been created" do
        visit root_path
        page.should have_selector('h2', text: 'Provide Feedback For')
        page.should have_selector('table.invitations_received')
      end
    end
  end

  describe "invitations sent form" do
    let(:invited_user) { FactoryGirl.create(:user) }
    let!(:invitation) { review.invitations.create(email: invited_user.email) }

    it "should not display table if user is not logged in" do
      visit root_path
      page.should_not have_selector('h2', text:'Feedback Invitations Sent')
      page.should_not have_selector('table.invitations_sent')
    end

    it "should not display table if user has not sent any invitations" do
      sign_in invited_user
      visit root_path
      page.should_not have_selector('h2', text:'Feedback Invitations Sent')
      page.should_not have_selector('table.invitations_sent')
    end

    describe "as JC who has sent an invitation" do

      before { sign_in jc_user }

      it "should display table if user has sent invitations" do
        visit root_path
        page.should have_selector('h2', text:'Feedback Invitations Sent')
        page.should have_selector('table.invitations_sent')

        page.should_not have_selector('table.invitations_sent th', text: 'Reviewee')
        page.should have_selector('table.invitations_sent th', text: 'Invited')
        page.should have_selector('table.invitations_sent th', text: 'Review Type')
        page.should have_selector('table.invitations_sent th', text: 'Invitation Sent')
        page.should have_selector('table.invitations_sent th', text: 'Feedback Deadline')
        page.should have_selector('table.invitations_sent th', text: 'Status')
        page.should have_selector('table.invitations_sent th', text: 'Action')

        page.should_not have_selector('table.invitations_sent td', text: invitation.reviewee.name)
        page.should have_selector('table.invitations_sent td', text: invited_user.email)
        page.should have_selector('table.invitations_sent td', text: review.review_type)
        page.should have_selector('table.invitations_sent td', text: invitation.sent_date.to_s)
        page.should have_selector('table.invitations_sent td', text: review.feedback_deadline.to_s)
      end

      it "should have 'Not Started' status and 'Send Reminder' action if invited user has not responded." do
        visit root_path
        page.should have_selector('table.invitations_sent td', text: 'Not Started')
        page.should have_selector('table.invitations_sent td a', text: 'Send Reminder')

        mail = double(deliver: true)
        mail.should_receive(:deliver)
        UserMailer.should_receive(:feedback_reminder).and_return(mail)
        click_link 'Send Reminder'

        current_path.should == root_path
        page.should have_selector('div.alert.alert-notice', text: 'Reminder email was sent!')
      end

      it "should have 'Not Started' status and 'Send Reminder' action if the invited user has no account." do
        invitation.destroy
        review.invitations.create(email: 'example@example.com')
        visit root_path
        page.should have_selector('table.invitations_sent td', text: 'Not Started')
        page.should have_selector('table.invitations_sent td a', text: 'Send Reminder')

        mail = double(deliver: true)
        mail.should_receive(:deliver)
        UserMailer.should_receive(:feedback_reminder).and_return(mail)
        click_link 'Send Reminder'

        current_path.should == root_path
        page.should have_selector('div.alert.alert-notice', text: 'Reminder email was sent!')
      end

      it "should have 'Not Submitted' status and 'Send Reminder' action if the invited user has unsubmitted feedback." do
        FactoryGirl.create(:feedback, review: review, user: invited_user)
        visit root_path
        page.should have_selector('table.invitations_sent td', text: 'Not Submitted')
        page.should have_selector('table.invitations_sent td a', text: 'Send Reminder')

        mail = double(deliver: true)
        mail.should_receive(:deliver)
        UserMailer.should_receive(:feedback_reminder).and_return(mail)
        click_link 'Send Reminder'
        
        current_path.should == root_path
        page.should have_selector('div.alert.alert-notice', text: 'Reminder email was sent!')
      end

      it "should have 'Submitted' status and 'View' action if the invited user has submitted feedback." do
        FactoryGirl.create(:submitted_feedback, review: review, user: invited_user)
        visit root_path
        page.should_not have_selector('table.invitations_sent td', text: 'Not')
        page.should have_selector('table.invitations_sent td', text: 'Submitted')
        page.should have_selector('table.invitations_sent td a', text: 'View')

        click_link 'View'
        current_path.should == review_feedback_path(review, invitation.feedback)
      end
    end
    
    describe "as an admin" do

      before { sign_in admin }

      it "should display table if user is admin" do
        visit root_path
        page.should have_selector('h2', text: 'Feedback Invitations Sent')
        page.should have_selector('table.invitations_sent')

        page.should have_selector('table.invitations_sent th', text: 'Reviewee')
        page.should have_selector('table.invitations_sent th', text: 'Invited')
        page.should have_selector('table.invitations_sent th', text: 'Review Type')
        page.should have_selector('table.invitations_sent th', text: 'Invitation Sent')
        page.should have_selector('table.invitations_sent th', text: 'Feedback Deadline')
        page.should have_selector('table.invitations_sent th', text: 'Status')

        page.should have_selector('table.invitations_sent td', text: invitation.reviewee.name)
        page.should have_selector('table.invitations_sent td', text: invited_user.email)
        page.should have_selector('table.invitations_sent td', text: review.review_type)
        page.should have_selector('table.invitations_sent td', text: invitation.sent_date.to_s)
        page.should have_selector('table.invitations_sent td', text: review.feedback_deadline.to_s)
      end

      it "should have 'Not Started' status if invited user has not responded." do
        visit root_path
        page.should have_selector('table.invitations_sent td', text: 'Not Started')
      end

      it "should have 'Not Started' status if the invited user has no account." do
        invitation.destroy
        review.invitations.create(email: 'example@example.com')
        visit root_path
        page.should have_selector('table.invitations_sent td', text: 'Not Started')
      end

      it "should have 'Not Submitted' status if the invited user has saved but not submitted feedback." do
        FactoryGirl.create(:feedback, review: review, user: invited_user)
        visit root_path
        page.should have_selector('table.invitations_sent td', text: 'Not Submitted')
      end

      it "should have 'Submitted' status if the invited user has submitted feedback." do
        FactoryGirl.create(:submitted_feedback, review: review, user: invited_user)
        visit root_path
        page.should_not have_selector('table.invitations_sent td', text: 'Not')
        page.should have_selector('table.invitations_sent td', text: 'Submitted')
      end
    end
  end
end