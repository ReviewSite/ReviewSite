require 'spec_helper'

describe "Review pages" do
  let(:admin) { FactoryGirl.create(:admin_user) }
  let(:jc) { FactoryGirl.create(:junior_consultant) }
  let(:jc_user) { FactoryGirl.create(:user, email: jc.email) }

  subject { page }

  describe "summary page" do
    before { sign_in admin }

    describe "export as excel spreadsheet" do
      it "should not raise error if JC name is over 31 characters" do
        long_name_jc = FactoryGirl.create(:junior_consultant, name: "aaaaa bbbbb ccccc ddddd eeeee ff")
        review = FactoryGirl.create(:review, junior_consultant: long_name_jc)
        feedback = FactoryGirl.create(:feedback, review: review, submitted: true)
        visit summary_review_path(review)
        expect{ click_link "export_to_excel" }.not_to raise_error
      end
    end
  end

  describe "show page" do
    before { sign_in admin }
    it "can navigate to the reviewer invitation page" do
      review = FactoryGirl.create(:review, junior_consultant: jc)
      visit review_path(review)
      click_link 'Invite Reviewer'
      page.should have_selector('h1', text: 'Invite Reviewer')
    end
  end

  describe "invitation page" do
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