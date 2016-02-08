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

    context "when review is in the past" do
      it "should show submit-assessment button" do
        @review = create(:review, associate_consultant: ac,
          review_date: Date.today - 5.years, review_type: "6-Month", feedback_deadline: Date.today - 6.years)
        visit review_path(@review)

        page.should have_selector("a", text: "Submit Self-Assessment")
      end

      it "should show ask-for-feedback button" do
        @review = create(:review, associate_consultant: ac,
          review_date: Date.today - 5.years, review_type: "6-Month", feedback_deadline: Date.today - 6.years)
        visit review_path(@review)

        page.should have_selector("a", text: "Ask For Feedback")
      end

      it "should show record external feedback button" do
        @review = create(:review, associate_consultant: ac,
          review_date: Date.today - 5.years, review_type: "6-Month", feedback_deadline: Date.today - 6.years)
        visit review_path(@review)

        page.should have_selector("a", text: "Record External Feedback")
      end
    end
  end
end
