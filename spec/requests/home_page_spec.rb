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

        it {should have_selector("#reviews td", text: ac.reviewing_group.name) }
        it {should have_selector("table#reviews td", text: ac.user.name) }
        it {should have_selector("table#reviews td", text: review.review_type) }
        it {should have_selector("table#reviews td", text: review.review_date.to_s) }
        it {should have_selector("table#reviews td", text: review.feedback_deadline.to_s) }
        it {should have_selector("table#reviews td", text: "0 / 1") }

        it "updates submitted feedback count" do
          feedback.update_attribute(:submitted, true)
          visit root_path
          subject.should have_selector("table#reviews td", text: "1 / 1")
        end

        it "links to review summary page" do
          within("table#reviews") do
            click_link 'Feedback Summary'
          end
          current_path.should == summary_review_path(review)
        end

        it "links to review show page" do
          within("table#reviews") do
            click_link 'Show Details'
          end
          current_path.should == review_path(review)
        end

      end
    end

    describe "as AC" do
      before do
        @ac_with_many_reviews = FactoryGirl.create(:associate_consultant)
        @first_review = FactoryGirl.create(:new_review_type, :associate_consultant => @ac_with_many_reviews, :review_type => "12-Month", :review_date => Date.today - 6.months)
        @upcoming_review = FactoryGirl.create(:new_review_type, :associate_consultant => @ac_with_many_reviews, :review_type => "18-Month", :review_date => Date.today)
        @latest_review = FactoryGirl.create(:new_review_type, :associate_consultant => @ac_with_many_reviews, :review_type => "24-Month", :review_date => Date.today + 6.months)
        @feedback = FactoryGirl.create(:feedback, review: @upcoming_review, user: reviewer, project_worked_on: "Test")

        sign_in @ac_with_many_reviews.user
      end

      it { should_not have_selector("a", text: "Show") }

      it "links to reviewer invitation page" do
        click_link 'Request Feedback'
        current_path.should == new_review_invitation_path(@upcoming_review)
      end

      it "links to review summary page" do
        click_link 'View Summary'
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
        page.should have_selector("h2", text: @upcoming_review.review_type.titleize)
        page.should_not have_selector("h2", text: @latest_review.review_type.titleize)
        page.should_not have_selector("h2", text: @first_review.review_type.titleize)
      end

    end

    describe "as a coach", js: true do
      before { sign_in coach }

      it "links to review summary page" do
        click_link 'Feedback Summary'
        current_path.should == summary_review_path(review)
      end
    end
  end

end
