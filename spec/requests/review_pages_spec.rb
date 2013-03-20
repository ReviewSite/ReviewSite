require 'spec_helper'

describe "Review pages" do
  let(:admin) { FactoryGirl.create(:admin_user) }
  let(:jc) { FactoryGirl.create(:junior_consultant) }

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
end