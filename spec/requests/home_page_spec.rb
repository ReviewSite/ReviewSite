require 'spec_helper'

describe "Home page" do
  let (:admin) { FactoryGirl.create :admin_user }
  let (:coach) { FactoryGirl.create :user }
  let (:reviewer) { FactoryGirl.create :user }
  let (:ac_user) { FactoryGirl.create :user}
  let! (:ac) { FactoryGirl.create :associate_consultant, coach: coach, :user => ac_user }
  let! (:review) { FactoryGirl.create :review, associate_consultant: ac, feedback_deadline: Date.tomorrow }
  let! (:feedback) { FactoryGirl.create :feedback, review: review, user: reviewer, project_worked_on: "Test"}

  subject { page }

  describe "new review button" do
    it "is visible to admins" do
      sign_in admin
      click_link "New Review"
      current_path.should == new_review_path
    end

    it "is invisible to other users" do
      page.should_not have_link("New Review")
      sign_in FactoryGirl.create(:user)
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
        @ac_with_many_reviews = FactoryGirl.create(:associate_consultant)
        @first_review = FactoryGirl.create(:new_review_type, :associate_consultant => @ac_with_many_reviews, :review_type => "12-Month", :review_date => Date.today - 7.months)
        @upcoming_review = FactoryGirl.create(:new_review_type, :associate_consultant => @ac_with_many_reviews, :review_type => "18-Month", :review_date => Date.today + 1.month)
        @latest_review = FactoryGirl.create(:new_review_type, :associate_consultant => @ac_with_many_reviews, :review_type => "24-Month", :review_date => Date.today + 7.months)
        @feedback = FactoryGirl.create(:feedback, review: @upcoming_review, user: reviewer, project_worked_on: "Test")

        sign_in @ac_with_many_reviews.user
      end

      it { should_not have_selector("a", text: "Show") }

      it "links to reviewer invitation page" do
        click_link 'Ask for Feedback'
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
        page.should have_selector("h1", text: "Your Upcoming " + @ac_with_many_reviews.upcoming_review.review_type + " Review")
        page.should_not have_selector("h1", text: @latest_review.review_type.upcase)
        page.should_not have_selector("h1", text: @first_review.review_type.upcase)
      end

      describe "who is also a coach" do
        it "should contain a table of coachee reviews" do
          coach_ac = FactoryGirl.create(:associate_consultant, user: FactoryGirl.create(:user))
          @ac_with_many_reviews.coach = coach_ac.user
          coach_ac.user.coachees << @ac_with_many_reviews
          sign_in coach_ac.user
          page.should have_selector("h1", text: "Watched Reviews")
        end
      end

      describe "who has graduated", js: true do
        before do
          graduated_ac = FactoryGirl.create(:associate_consultant,
            user: FactoryGirl.create(:user), graduated: true)
          @ac_with_many_reviews.coach = graduated_ac.user
          graduated_ac.user.coachees << @ac_with_many_reviews
          sign_in graduated_ac.user
        end

        it "should show coachee reviews" do
          page.should have_selector('h1', text: "Watched Reviews".upcase)
        end

        it "should not see 'Your Upcoming Review'" do
          page.should_not have_selector('h1', text: "YOUR UPCOMING REVIEW")
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
