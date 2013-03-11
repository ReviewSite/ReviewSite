require 'spec_helper'

describe "Review pages" do
  let(:admin) { FactoryGirl.create(:admin_user) }

  subject { page }

  before { sign_in admin }

  describe "summary page" do
    describe "export as excel spreadsheet" do
      it "should not raise error if JC name is over 31 characters" do
        jc = FactoryGirl.create(:junior_consultant, name: "aaaaa bbbbb ccccc ddddd eeeee ff")
        review = FactoryGirl.create(:review, junior_consultant: jc)
        feedback = FactoryGirl.create(:feedback, review: review, submitted: true)
        visit summary_review_path(review)
        expect{ click_link "export_to_excel" }.not_to raise_error
      end
    end
  end

  describe "show page" do
    it "can navigate to the reviewer invitation page" do
      jc = FactoryGirl.create(:junior_consultant)
      review = FactoryGirl.create(:review, junior_consultant: jc)
      visit review_path(review)
      click_link 'Invite Reviewer'
      page.should have_selector('h1', text: 'Invite Reviewer')
    end
  end

  describe "invitation page" do
    it "can send an invitation" do
      jc = FactoryGirl.create(:junior_consultant)
      review = FactoryGirl.create(:review, junior_consultant: jc)
      visit new_review_invitation_path(review)
      fill_in "Email", with: "reviewer@example.com"
      fill_in "Personalized message", with: "Why, hello!"
      click_button "Send invite"
      current_path.should == root_path
      page.should have_selector('div.alert.alert-notice')
    end
  end
end