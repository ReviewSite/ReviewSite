require 'spec_helper'

describe "Invitations" do
  let(:admin) { FactoryGirl.create(:admin_user) }
  let(:ac_user) { FactoryGirl.create(:user) }
  let(:ac) { FactoryGirl.create(:associate_consultant, :user => ac_user) }
  let(:review) { FactoryGirl.create(:review, associate_consultant: ac, feedback_deadline: Date.tomorrow) }
  let(:invited_user) { FactoryGirl.create(:user, :email => "invited@thoughtworks.com") }
  let(:uninvited_user) { FactoryGirl.create(:user, :email => "uninvited@thoughtworks.com") }

  subject { page }

  describe "invitation form" do

    context "as admin" do
      before do
        sign_in admin
        visit new_review_invitation_path(review)
        fill_in "emails", with: "reviewer@thoughtworks.com"
        fill_in "message", with: "Why, hello!"
      end

      it "redirects to home page after submission" do
        click_button "Send Request"
        current_path.should == root_path
        page.should have_selector('.flash-success', text: "An invitation has been sent to: reviewer@thoughtworks.com")
      end

      it "sends an invitation email" do
        UserMailer.should_receive(:review_invitation).and_return(double(deliver: true))
        click_button "Send Request"
      end

      it "does not send an email if the 'No email' option is selected" do
        UserMailer.should_not_receive(:review_invitation)
        check "no_email"
        click_button "Send Request"
        current_path.should == root_path
        page.should have_selector('.flash-success', text: "An invitation has been created for: reviewer@thoughtworks.com")
      end
    end

    context "as ac" do
      before do
        sign_in ac_user
        visit new_review_invitation_path(review)
        fill_in "emails", with: "reviewer@thoughtworks.com"
        fill_in "message", with: "Why, hello!"
      end

      it "redirects to home page after submission" do
        click_button "Send Request"
        current_path.should == root_path
        page.should have_selector('.flash-success')
      end

      it "sends an invitation email" do
        UserMailer.should_receive(:review_invitation).and_return(double(deliver: true))
        click_button "Send Request"
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

    context "as invited user" do
      let!(:invitation) { FactoryGirl.create(:invitation, :review => review, :email => "invited@thoughtworks.com") }

      it "should let user decline invitation" do
        sign_in invited_user
        visit feedbacks_user_path(invited_user)
        expect do
          find("a[href^=\"" + review_invitation_path(review, invitation) + "\"]").click()
        end.to change(Invitation, :count).by(-1)
      end

      it "should let user submit HTTP request to decline invitation" do
        sign_in invited_user
        expect do
          page.driver.submit :delete, review_invitation_path(review, invitation), {}
        end.to change(Invitation, :count).by(-1)
      end

      it "should not let uninvited non-admin user decline invitation" do
        sign_in uninvited_user
        expect do
          page.driver.submit :delete, review_invitation_path(review, invitation), {}
        end.to change(Invitation, :count).by(0)
      end
    end
  end
end
