require 'spec_helper'

describe "Side Navbar" do
  subject { page }

  describe "Self Assessment Link" do
    let!(:user) { create(:user) }
    let!(:ac) { create(:associate_consultant, user: user) }

    before { sign_in user }

    context "when review is upcoming" do
      it "should show submit self-assessment button" do
        @review = create(:review, associate_consultant: ac,
          review_date: Date.today + 3.days, review_type: "18-Month")
        visit review_path(@review)

        page.should have_selector("a", text: "Submit Self-Assessment")
      end
    end

    context "when review is beyond two weeks old" do
      it "should not show submit-assessment button" do
        @review = create(:review, associate_consultant: ac,
          review_date: Date.today - 5.years, review_type: "6-Month", feedback_deadline: Date.today - 6.years)
        visit review_path(@review)

        page.should_not have_selector("a", text: "Submit Self-Assessment")
      end
    end

    context "when review happened recently (within two weeks)" do
      it "should show submit self-assessment button" do
        @review = create(:review, associate_consultant: ac,
          review_date: Date.today - 2.weeks, review_type: "6-Month", feedback_deadline: Date.today - 3.weeks)
        visit review_path(@review)

        page.should have_selector("a", text: "Submit Self-Assessment")
      end
    end
  end
end
