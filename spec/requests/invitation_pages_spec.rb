require 'spec_helper'

describe "Invitations" do
  let(:admin) { FactoryGirl.create(:admin_user) }
  let(:ac_user) { FactoryGirl.create(:user) }
  let(:ac) { FactoryGirl.create(:associate_consultant, :user => ac_user) }
  let (:review) { FactoryGirl.create(:review, associate_consultant: ac, feedback_deadline: Date.tomorrow) }

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
  end
end
