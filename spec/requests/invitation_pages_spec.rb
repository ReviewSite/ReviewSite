require 'spec_helper'

describe "Invitations" do
  let(:admin) { FactoryGirl.create(:admin_user) }
  let(:jc_user) { FactoryGirl.create(:user) }
  let(:jc) { FactoryGirl.create(:junior_consultant, :user => jc_user) }
  let (:review) { FactoryGirl.create(:review, junior_consultant: jc, feedback_deadline: Date.tomorrow) }

  subject { page }

  describe "invitation form" do

    context "as admin" do
      before do
        sign_in admin
        visit new_review_invitation_path(review)
        fill_in "username", with: "reviewer"
        fill_in "message", with: "Why, hello!"
      end

      it "redirects to home page after submission" do
        click_button "Create Invitation"
        current_path.should == root_path
        page.should have_selector('div.alert.alert-notice', text: "An invitation has been sent!")
      end

      it "sends an invitation email" do
        UserMailer.should_receive(:review_invitation).and_return(double(deliver: true))
        click_button "Create Invitation"
      end

      it "does not send an email if the 'No email' option is selected" do
        UserMailer.should_not_receive(:review_invitation)
        check "no_email"
        click_button "Create Invitation"
        current_path.should == root_path
        page.should have_selector('div.alert.alert-notice', text: "An invitation has been created!")
      end
    end

    context "as jc" do
      before do
        sign_in jc_user
        visit new_review_invitation_path(review)
        fill_in "username", with: "reviewer"
        fill_in "message", with: "Why, hello!"
      end

      it "redirects to home page after submission" do
        click_button "Create Invitation"
        current_path.should == root_path
        page.should have_selector('div.alert.alert-notice')
      end

      it "sends an invitation email" do
        UserMailer.should_receive(:review_invitation).and_return(double(deliver: true))
        click_button "Create Invitation"
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
end
