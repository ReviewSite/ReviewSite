require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { title.should == "Review Site | Edit user" }
    end

    describe "with valid information" do
      let(:new_name)  { "Imma NewName" }
      let(:new_email) { "immanew@example.com" }

      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        click_button "Save changes"
      end

      it "should derpaderp" do
        current_path.should eql root_path
#        current_path.should eql user_path(user)
      end

      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end

    describe "with invalid information" do
      before do
        fill_in "Name", with: "a"
        fill_in "Email", with: "b"
        click_button "Save changes"
      end
      it { should have_content('error') }
    end
  end

  describe "new" do
    before { ActionMailer::Base.deliveries.clear }

    describe "as a new user" do
      before {
        visit root_path
        within "#okta-input" do
          fill_in "temp-okta", with: "roberto"
          click_button "Set OKTA"
        end
        visit new_user_path
      }

      it "re-renders page with error message if invalid information" do
        click_button "Create Account"
        page.should have_selector('h1', text: 'New user')
        page.should have_content('error')
      end

      it "creates an account and sends an email" do

        fill_in "Name", with: "Bob Smith"
        fill_in "Email", with: "test@example.com"
        click_button 'Create Account'

        current_path.should eql root_path
        # breakpoint
        page.should have_selector('div.alert.alert-success', text: 'User has been successfully created.')

        ActionMailer::Base.deliveries.length.should == 1
        mail = ActionMailer::Base.deliveries.last
        mail.to.should == ["test@example.com"]
        mail.subject.should == "You were registered on the ReviewSite"

        new_user = User.last
        new_user.name.should == "Bob Smith"
        new_user.email.should == "test@example.com"
      end
    end

    describe "as an admin" do
      it "creates an account and sends an email" do
        sign_in FactoryGirl.create(:admin_user)
        visit new_user_path
        fill_in "Name", with: "Bob Smith"
        fill_in "Email", with: "test@example.com"
        fill_in "Okta name", with: "roberto"
        click_button 'Create Account'

        current_path.should eql users_path
        page.should have_selector('div.alert.alert-success', text: 'User has been successfully created.')

        ActionMailer::Base.deliveries.length.should == 1
        mail = ActionMailer::Base.deliveries.last
        mail.to.should == ["test@example.com"]
        mail.subject.should == "You were registered on the ReviewSite"

        new_user = User.last
        new_user.name.should == "Bob Smith"
        new_user.email.should == "test@example.com"
      end
    end

    describe "as a non-admin user" do
      it "does not allow other logged-in users to create new users" do
        sign_in FactoryGirl.create(:user)
        visit new_user_path
        current_path.should == root_path
        page.should have_selector('div.alert.alert-alert', text: "You are not authorized to access this page.")
      end
    end
  end

  describe "show" do
    let (:admin) { FactoryGirl.create(:admin_user) }
    let!(:user) { FactoryGirl.create(:user) }

    describe "as an admin" do
      before do
        sign_in admin
        visit user_path(user)
      end

      it { should have_content(user.name) }
      it { should have_content(user.email) }
      it { should have_content("Admin: false") }

      it "links to edit page" do
        click_link "Edit"
        current_path.should == edit_user_path(user)
      end

      it "links to users index page" do
        click_link "Back"
        current_path.should == users_path
      end
    end

    describe "as a non-admin" do
      before do
        sign_in user
        visit user_path(user)
      end

      it "is inaccessible" do
        current_path.should == root_path
        page.should have_selector('div.alert.alert-alert', text: 'You are not authorized to access this page.')
      end
    end
  end

  describe "index" do
    let!(:user) { FactoryGirl.create(:user, name: 'Andy', email: 'andy@example.com') }
    let!(:admin) { FactoryGirl.create(:admin_user) }

    describe "as an admin" do
      before do
        sign_in admin
        visit users_path
      end

      it { should have_selector('h1', text: 'Manage Users') }
      it { should have_selector('th', text: 'Name') }
      it { should have_selector('th', text: 'Email') }
      it { should have_selector('th', text: 'Admin') }

      it { should have_selector('td', text: 'Andy') }
      it { should have_selector('td', text: 'andy@example.com') }
      it { should have_selector('td', text: 'false') }
      it { should have_selector('td', text: admin.name) }
      it { should have_selector('td', text: admin.email) }
      it { should have_selector('td', text: 'true') }

      it "should link to new" do
        click_link "New User"
        current_path.should == new_user_path
      end

      it "should link to show" do
        within(:xpath, '//tr[contains(.//td/text(), "Andy")]') do
          click_link "View Profile"
          current_path.should == user_path(user)
        end
      end

      it "should link to edit" do
        within(:xpath, '//tr[contains(.//td/text(), "Andy")]') do
          click_link "Edit"
          current_path.should == edit_user_path(user)
        end
      end

      it "should link to destroy", js: true do
        page.driver.browser.accept_js_confirms
        within(:xpath, '//tr[contains(.//td/text(), "Andy")]') do
          click_link "Delete"
          current_path.should == users_path
        end
        page.should have_selector('div.alert.alert-success', text: 'User deleted.')
        page.should_not have_selector('td', text: 'Andy')
        page.should_not have_selector('td', text: 'andy@example.com')
        page.should_not have_selector('td', text: 'false')
      end
    end

    describe "as a non-admin" do
      before do
        sign_in user
        visit users_path
      end

      it "is inaccessible" do
        current_path.should == root_path
        page.should have_selector('div.alert.alert-alert', text: 'You are not authorized to access this page.')
      end
    end
  end

  describe "feedbacks" do
    let(:reviewer) { FactoryGirl.create(:user) }
    let(:jc) { FactoryGirl.create(:junior_consultant) }
    let(:review) { FactoryGirl.create(:review, junior_consultant: jc) }
    let!(:feedback) { FactoryGirl.create(:feedback, review: review, user: reviewer) }

    describe "as the reviewer" do
      before do
        sign_in reviewer
      end

      it "displays the feedback with a 'Continue' action if not submitted" do
        visit feedbacks_user_path(reviewer)
        page.should have_selector('.feedbacks td', text: jc.name)
        page.should have_selector('.feedbacks td', text: review.review_type)
        page.should have_selector('.feedbacks td', text: review.feedback_deadline.to_s)
        page.should have_selector('.feedbacks td', text: feedback.updated_at.to_date.to_s)
        page.should have_selector('.feedbacks td', text: "Not Submitted")
        page.should have_selector('.feedbacks td a', text: "Continue")
        click_link "Continue"
        current_path.should == edit_review_feedback_path(review, feedback)
      end


      it "displays the feedback with a 'View' action if submitted" do
        feedback.update_attribute(:submitted, true)
        visit feedbacks_user_path(reviewer)

        page.should have_selector('.feedbacks td', text: jc.name)
        page.should have_selector('.feedbacks td', text: review.review_type)
        page.should have_selector('.feedbacks td', text: review.feedback_deadline.to_s)
        page.should have_selector('.feedbacks td', text: feedback.updated_at.to_date.to_s)
        page.should have_selector('.feedbacks td', text: "Submitted")
        page.should_not have_selector('.feedbacks td', text: "Not")
        page.should have_selector('.feedbacks td a', text: "View")
        click_link "View"
        current_path.should == review_feedback_path(review, feedback)
      end
    end

    describe "as another user" do
      before do
        sign_in FactoryGirl.create(:user)
        visit feedbacks_user_path(reviewer)
      end

      it "is inaccessible" do
        current_path.should == root_path
        page.should have_selector('div.alert.alert-alert', text: 'You are not authorized to access this page.')
      end
    end
  end
end
