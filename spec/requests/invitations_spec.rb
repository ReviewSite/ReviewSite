require 'spec_helper'

describe "Invitations" do  
  let(:admin) { FactoryGirl.create(:admin_user) }
  let(:jc) { FactoryGirl.create(:junior_consultant) }
  let(:jc_user) { FactoryGirl.create(:user, email: jc.email) }
  let (:review) { FactoryGirl.create(:review, junior_consultant: jc, feedback_deadline: Date.tomorrow) }

  subject { page }

  describe "invitation form" do
    
    context "as admin" do
      before do
        sign_in admin
        visit new_review_invitation_path(review)
        fill_in "email", with: "reviewer@example.com"
        fill_in "message", with: "Why, hello!"
      end

      it "redirects to home page after submission" do
        click_button "Send invite"
        current_path.should == root_path
        page.should have_selector('div.alert.alert-notice')
      end

      it "sends an invitation email" do
        UserMailer.should_receive(:review_invitation).and_return(double(deliver: true))
        click_button "Send invite"
      end
    end

    context "as jc" do
      before do
        sign_in jc_user
        visit new_review_invitation_path(review)
        fill_in "email", with: "reviewer@example.com"
        fill_in "message", with: "Why, hello!"
      end

      it "redirects to home page after submission" do
        click_button "Send invite"
        current_path.should == root_path
        page.should have_selector('div.alert.alert-notice')
      end

      it "sends an invitation email" do
        UserMailer.should_receive(:review_invitation).and_return(double(deliver: true))
        click_button "Send invite"
      end
    end

    context "as other user" do
      it "should not be accessible to other users" do
        other_user = FactoryGirl.create(:user)
        sign_in other_user
        visit new_review_invitation_path(review)
        current_path.should == root_path
      end
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
        page.should have_selector('h2', text: 'Provide feedback for')
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
        page.should_not have_selector('h2', text: 'Provide feedback for')
        page.should_not have_selector('table.invitations_received')
      end

      it "should display invitation if feedback was created but not submitted" do
        FactoryGirl.create(:feedback, review: review, user: invited_user)
        visit root_path
        page.should have_selector('h2', text: 'Provide feedback for')
        page.should have_selector('table.invitations_received')
      end

      it "should display invitation if feedback hasn't been created" do
        visit root_path
        page.should have_selector('h2', text: 'Provide feedback for')
        page.should have_selector('table.invitations_received')
      end
    end
  end
end