require 'spec_helper'

# Adam logs into the review site.
# Nobody has invited him to give them feedback.
# --He sees no feedback invitations table.

# Betty has a review coming up.
# The feedback deadline is 4/1/13
# Betty logs into the review site.
# She visits the invitation form.
# She invites Adam to give her feedback.
# She invites Carlos to give her feedback.

# Adam logs into the review site.
# --He sees the invitation from Betty.
# --The status is "Not started," and the action is "Create."
# He clicks on "Create."
# --He is directed to the new feedback form.
# He fills out the form and clicks "Save draft."
# He visits the home page.
# --The status is "Not submitted," and the action is "Edit."
# He clicks on "Edit."
# --He is directed to the edit feedback form.
# He clicks "Submit Final."
# He visits the home page.
# --The status is "Submitted," and the action is "View."
# He clicks on "View."
# --He is directed to the show feedback page.

# It is 4/2/13.

# Adam logs into the review site.
# --He no longer sees the invitation from Betty.

# Carlos logs into the review site.
# --He sees the invitation from Betty.
# He clicks on "Create."
# He fills out the form and clicks "Submit final."
# He visits the home page.
# --He no longer sees the invitation from Betty.

describe "Invitations" do  
  let(:admin) { FactoryGirl.create(:admin_user) }
  let(:jc) { FactoryGirl.create(:junior_consultant) }
  let(:jc_user) { FactoryGirl.create(:user, email: jc.email) }

  describe "invitation form" do
    let (:review) { FactoryGirl.create(:review, junior_consultant: jc) }

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
end