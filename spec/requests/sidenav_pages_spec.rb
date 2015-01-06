require 'spec_helper'

describe "Side Navbar" do
  subject { page }

  describe "Self Assessment Link" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:ac) { FactoryGirl.create(:associate_consultant,
      user: user) }

    before do
      sign_in user
    end

    context "when review is upcoming" do
      it "should show submit self-assessment button" do
        @review = FactoryGirl.create(:review, associate_consultant: ac,
          review_date: Date.today + 3.days, review_type: "18-Month")
        visit review_path(@review)

        page.should have_selector("a", text: "Submit Self-Assessment")
      end
    end

    context "when review is beyond two weeks old" do
      it "should not show submit-assessment button" do
        @review = FactoryGirl.create(:review, associate_consultant: ac,
          review_date: Date.today - 5.years, review_type: "6-Month")
        visit review_path(@review)

        page.should_not have_selector("a", text: "Submit Self-Assessment")
      end
    end

    context "when review happened recently (within two weeks)" do
      it "should show submit self-assessment button" do
        @review = FactoryGirl.create(:review, associate_consultant: ac,
          review_date: Date.today - 2.weeks, review_type: "6-Month")
        visit review_path(@review)

        page.should have_selector("a", text: "Submit Self-Assessment")
      end
    end
  end
end
