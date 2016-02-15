require 'spec_helper'

describe "Home page" do
  let (:admin) { create :admin_user }
  let (:coach) { create :user }
  let (:reviewer) { create :user }
  let (:ac_user) { create :user}
  let! (:ac) { create :associate_consultant, coach: coach, :user => ac_user }
  let! (:review) { create :review, associate_consultant: ac}
  let! (:feedback) { create :feedback, review: review, user: reviewer, project_worked_on: "Test"}

  subject { page }

  describe "new review button" do
    it "is visible to admins" do
      sign_in admin
      click_link "New Review"
      current_path.should == new_review_path
    end

    it "is invisible to other users" do
      page.should_not have_link("New Review")
      sign_in create(:user)
      page.should_not have_link("New Review")
    end
  end

  describe "reviews table" do
    describe "as admin" do
      before { sign_in admin }

      describe "supports ajax pagination", :js => true do

        it {should have_selector("table#reviews td", text: ac.user.name) }
        it {should have_selector("table#reviews td", text: review.review_type) }
        it {should have_selector("table#reviews td", text: review.review_date.to_s(:short_date)) }

        it "links to review show page" do
          within("table#reviews") do
            page.find(".fa-eye").click
          end
          current_path.should == review_path(review)
        end

      end
    end

    describe "as AC" do
      before do
        @ac_with_many_reviews = create(:associate_consultant)
        @first_review = build(:review, associate_consultant: @ac_with_many_reviews, review_type: "12-Month", review_date: Date.today - 7.months)
        @first_review.stub(:feedback_deadline_is_before_review_date).and_return(true)
        @first_review.save
        @upcoming_review = create(:review, associate_consultant: @ac_with_many_reviews, review_type: "18-Month", review_date: Date.today + 1.month)
        @latest_review = create(:review, associate_consultant: @ac_with_many_reviews, review_type: "24-Month", review_date: Date.today + 7.months)
        @feedback = create(:feedback, review: @upcoming_review, user: reviewer, project_worked_on: "Test")

        sign_in @ac_with_many_reviews.user
      end

      it { should_not have_selector("a", text: "Show") }

      it "links to reviewer invitation page" do
        find("a[href*='/invitations/new']").click
        current_path.should == new_review_invitation_path(@upcoming_review)
      end

      it "links to review summary page" do
        click_link 'Feedback Summary'
        current_path.should == summary_review_path(@upcoming_review)
      end

      it "shows the name of the reviewer of additional feedback when it is not the same as the user" do
        @feedback.update_attribute(:submitted, true)
        @feedback.update_attribute(:user_string, "Additional Feedback Reviewer")
        visit root_path
        subject.should have_selector("table.feedback td", text: @feedback.user_string)
      end

      it "should only show the most recent review" do
        @ac_with_many_reviews.reviews.count.should eq(3)
        page.should have_selector("h1", text: "Your " + @ac_with_many_reviews.upcoming_review.review_type + " Review")
        page.should_not have_selector("h1", text: @latest_review.review_type.upcase)
        page.should_not have_selector("h1", text: @first_review.review_type.upcase)
      end

      it "should show the link to delete externally recorded feedback" do
        @feedback.update_attribute(:reported_by, Feedback::SELF_REPORTED)
        visit root_path
        id_link = review_feedback_path(@feedback.review, @feedback)
        page.should have_selector("a[href='#{id_link}'].fa-trash")
      end

      describe "who has graduated", js: true do
        before do
          graduated_ac = create(:associate_consultant,
            user: create(:user), graduated: true)
          @ac_with_many_reviews.coach = graduated_ac.user
          graduated_ac.user.coachees << @ac_with_many_reviews
          sign_in graduated_ac.user
        end

        it "should show coachee reviews" do
          page.should have_selector('h1', text: "Watched Reviews".upcase)
        end
      end
    end

    describe "as a coach", js: true do
      before { sign_in coach }

      it "links to review summary page" do
        page.find(".fa-eye").click
        click_link 'Feedback Summary'
        current_path.should == summary_review_path(review)
      end
    end
  end
end
