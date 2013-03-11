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
end