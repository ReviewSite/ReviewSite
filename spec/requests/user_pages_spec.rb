require 'spec_helper'

describe "User pages: " do
  subject { page }

  describe "EDIT/UPDATE" do
    let(:user) { FactoryGirl.create(:user) }
    let(:admin_user) { FactoryGirl.create(:admin_user) }
    let!(:reviewing_group) { FactoryGirl.create(:reviewing_group) }

    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector('h1',    text: "Update Your Profile") }
      it { title.should == "Review Site | Edit User" }
    end

    describe "user with valid information" do
      let(:new_name)  { "Imma NewName" }
      let(:new_email) { "immanew@example.com" }

      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        click_button "Save Changes"
      end

      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end

    describe "user with invalid information" do
      before do
        fill_in "Name", with: "a"
        fill_in "Email", with: "b"
        click_button "Save Changes"
      end
      it { should have_content('error') }
    end

    describe "as an admin" do
      it "can make another user an admin" do
        nonadmin = FactoryGirl.create(:user)
        sign_in admin_user

        visit users_path
        page.should have_selector("tr#user_#{nonadmin.id} td.admin", text: '')

        visit edit_user_path(nonadmin)
        page.find("#user_associate_consultant_attributes_graduated").should be_disabled
        page.find('[name="user[associate_consultant_attributes][graduated]"][type="hidden"]').should be_disabled
        check('user_admin')

        click_button "Save Changes"

        page.should have_selector("tr#user_#{nonadmin.id} td.admin", text: 'yes')

        sign_in nonadmin
        page.should have_selector("#admin-menu")
      end

      it "can graduate an AC", js: true do
        nonadmin = FactoryGirl.create(:user)
        sign_in admin_user

        visit users_path
        page.should have_selector("tr#user_#{nonadmin.id} td.admin", text: '')

        visit edit_user_path(nonadmin)
        check("isac")
        page.find("#user_associate_consultant_attributes_graduated", visible: true).set(true)
        select reviewing_group.name, from: "Reviewing group"

        click_button "Save Changes"

        current_path.should eql users_path

        visit user_path(nonadmin)
        page.should have_selector("#isAC", text: 'true')
        page.should have_selector("#hasGraduated", text: 'true')
      end
    end


  end

  describe "NEW/CREATE action" do
    before { ActionMailer::Base.deliveries.clear }

    describe "as a new user" do
      before {
        visit root_path
        within "#okta-input" do
          fill_in "temp-okta", with: "roberto"
          click_button "Set new OKTA user"
        end
        visit new_user_path
      }

      it "re-renders page with error message if invalid information" do
        click_button "Create Account"
        page.should have_selector('h1', text: 'Create an Account')
        page.should have_content('error')
      end

      it "creates an account and sends an email" do

        fill_in "Name", with: "Bob Smith"
        fill_in "Email", with: "test@example.com"
        click_button 'Create Account'

        current_path.should eql root_path
        page.should have_selector('div.alert.alert-success', text: 'User has been successfully created.')

        ActionMailer::Base.deliveries.length.should == 1
        mail = ActionMailer::Base.deliveries.last
        mail.to.should == ["test@example.com"]
        mail.subject.should == "[ReviewSite] You were registered!"

        new_user = User.last
        new_user.name.should == "Bob Smith"
        new_user.email.should == "test@example.com"
      end
    end

    describe "as an admin" do

      let!(:coach) { FactoryGirl.create(:coach) }
      let!(:reviewing_group) { FactoryGirl.create(:reviewing_group) }

      before do
        sign_in FactoryGirl.create(:admin_user)
        visit new_user_path
      end

      it "creates an account and sends an email" do
        fill_in "Name", with: "Bob Smith"
        fill_in "Email", with: "test@example.com"
        fill_in "Okta name", with: "roberto"
        click_button 'Create User'

        current_path.should eql users_path
        page.should have_selector('div.alert.alert-success', text: 'User has been successfully created.')

        ActionMailer::Base.deliveries.length.should == 1
        mail = ActionMailer::Base.deliveries.last
        mail.to.should == ["test@example.com"]
        mail.subject.should == "[ReviewSite] You were registered!"

        new_user = User.last
        new_user.name.should == "Bob Smith"
        new_user.email.should == "test@example.com"
      end

      it "creates a ac account" do
        fill_in "Name", with: "Roberto Glob"
        fill_in "Email", with: "test2@example.com"
        fill_in "Okta name", with: "glob"
        page.should have_selector("#user_associate_consultant_attributes_graduated", visible: false)
        check('isac')
        page.should have_selector("#user_associate_consultant_attributes_graduated", visible: true)

        fill_in "Notes", with: "Here are some notes"
        select reviewing_group.name, from: "Reviewing group"
        fill_in "Coach", with: coach.id

        click_button 'Create User'

        current_path.should eql users_path
        page.should have_selector('div.alert.alert-success', text: 'User has been successfully created.')

        new_user = User.last
        page.should have_selector("tr#user_#{new_user.id} td.ac", text: 'yes')

        visit user_path(new_user)

        new_ac = new_user.associate_consultant
        page.should have_selector("#isAC", text: 'true')
        page.should have_selector("#hasGraduated", text: 'false')
        page.should have_selector("#notes", text: new_ac.notes)
        page.should have_selector("#reviewing-group", text: new_ac.reviewing_group)
        page.should have_selector("#coach", text: new_ac.coach)

      end
    end

    describe "as a non-admin user" do

      it "cannot create new users" do
        sign_in FactoryGirl.create(:user)
        visit new_user_path
        current_path.should == root_path
        page.should have_selector('div.alert.alert-alert', text: "You are not authorized to access this page.")
      end
    end
  end

  describe "SHOW page" do
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

  describe "INDEX page" do
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
      it { should have_selector('td.admin', text: '') }
      it { should have_selector('td', text: admin.name) }
      it { should have_selector('td', text: admin.email) }
      it { should have_selector('td.admin', text: 'yes') }

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
        page.evaluate_script('window.confirm = function() { return true; }')
        within(:xpath, '//tr[contains(.//td/text(), "Andy")]') do
          click_link "Delete"
          current_path.should == users_path
        end
        page.should have_selector('div.alert.alert-success', text: 'User deleted.')
        page.should_not have_selector('td', text: 'Andy')
        page.should_not have_selector('td', text: 'andy@example.com')
        page.should_not have_selector('td.delete', text: 'false')
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

  describe "FEEDBACKS" do
    let(:reviewer) { FactoryGirl.create(:user) }
    let(:ac) { FactoryGirl.create(:associate_consultant) }
    let(:review) { FactoryGirl.create(:review, associate_consultant: ac) }
    let!(:feedback) { FactoryGirl.create(:feedback, review: review, user: reviewer) }

    describe "as the reviewer" do
      before do
        sign_in reviewer
      end

      it "displays the feedback with a 'Resume Feedback' action if not submitted" do
        visit feedbacks_user_path(reviewer)
        page.should have_selector('#feedbacks td', text: ac.user.name)
        page.should have_selector('#feedbacks td', text: review.review_type)
        page.should have_selector('#feedbacks td', text: review.feedback_deadline.to_s)
        page.should have_selector('#feedbacks td', text: feedback.updated_at.to_date.to_s)
        page.should have_selector('#feedbacks td a', text: "Resume Feedback")
        click_link "Resume Feedback"
        current_path.should == edit_review_feedback_path(review, feedback)
      end


      it "displays the feedback with a 'View Feedback' action if submitted" do
        feedback.update_attribute(:submitted, true)
        visit feedbacks_user_path(reviewer)

        page.should have_selector('#completeds td', text: ac.user.name)
        page.should have_selector('#completeds td', text: review.review_type)
        page.should have_selector('#completeds td', text: feedback.project_worked_on)
        page.should have_selector('#completeds td', text: feedback.updated_at.to_date.to_s)
        page.should have_selector('#completeds td a', text: "View")
        click_link "View Feedback"
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
