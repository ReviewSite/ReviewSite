require 'spec_helper'
include WaitForAjax


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
    end

    describe "user with valid information" do
      let(:new_name)  { "Imma NewName" }
      let(:new_email) { "immanew@example.com" }

      before do
        fill_in "Name",                     with: new_name
        fill_in "Email",                    with: new_email
        click_button "Save Changes"
      end

      it { should have_selector('.flash-success') }
      it { should have_link('Sign Out', href: signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end

    describe "user adds an additional email" do
      let(:new_name)  { "Imma NewName" }
      let(:new_email) { "immanew@example.com" }

      before do
        fill_in "Name",                     with: new_name
        fill_in "Email",                    with: new_email
      end

      describe "with valid, ThoughtWorks email", js: true do
        additional_email = "nottakenemail@thoughtworks.com"

        before do
          user = FactoryGirl.create(:user, okta_name: "nottaken",
            email: "randomemailthatworks@thoughtworks.com")
          fill_in "new-email",        with: additional_email
          click_link "Add"
        end

        it "should display the email" do
          page.should have_selector('.email-address-column',
            text: additional_email)
        end

        it "should create an additional email in the database" do
          wait_for_ajax
          AdditionalEmail.find_by_email(additional_email).email.eql? additional_email
          user.additional_emails.first.email.eql? additional_email
        end

        it "should send a confirmation email" do
          wait_for_ajax
          email = ActionMailer::Base.deliveries.last
          email.to.should == [additional_email]
        end
      end

      describe "with invalid, ThoughtWorks email", js: true do
        additional_email = "invalidthoughtworks.com"
        before do
          user = FactoryGirl.create(:user, okta_name: "reserved",
            email: "somethingnottaken@thoughtworks.com")
          fill_in "new-email",        with: additional_email
          click_link "Add"
        end

        it "should display the email with an error message" do
          page.should have_selector('.field-error-message',
            text: "Email is invalid")
        end

        it "should not create an additional email in the database" do
          wait_for_ajax
          AdditionalEmail.find_by_email(additional_email).should
          be_nil
        end
      end

      describe "with valid, non-ThoughtWorks email", js: true do
        it "should display the email with an error message" do
          additional_email = "valid@nontw.com"
          user = FactoryGirl.create(:user, okta_name: "nottaken",
            email: "somethingnottaken@thoughtworks.com")
          fill_in "new-email",              with: additional_email
          click_link "Add"

          page.should have_selector('.field-error-message',
            text: "Email must be a ThoughtWorks email")
        end
      end

      describe "with invalid email", js: true do
        it "should display the email with an error message" do
          additional_email = "invalidnontw.com"
          user = FactoryGirl.create(:user, okta_name: "nottaken",
          email: "somethingnottaken@thoughtworks.com")
          fill_in "new-email",              with: additional_email
          click_link "Add"

          page.should have_selector('.field-error-message',
            text: "Email is invalid")
        end
      end
    end

    describe "user with invalid information" do
      before do
        fill_in "Name", with: "a"
        fill_in "Email", with: "b"
        click_button "Save Changes"
      end
      it { should have_content('invalid') }
    end


    describe "as an admin", js: true do
      it "can make another user an admin" do
        nonadmin = FactoryGirl.create(:user)
        sign_in admin_user

        visit users_path
        id_selector = nonadmin.email.slice(0..(nonadmin.email.index('@'))-1)
        page.should_not have_selector("tr##{id_selector} .fa-key")

        visit edit_user_path(nonadmin)
        page.find("#user_associate_consultant_attributes_graduated", visible: false).should be_disabled
        page.find('[name="user[associate_consultant_attributes][graduated]"][type="hidden"]', visible: false).should be_disabled
        page.find("#user_admin").trigger("click")

        page.find("#user-form-submit").trigger("click")

        page.should have_selector("tr##{id_selector} .fa-key")

        sign_in nonadmin
        page.should have_selector("#admin-menu")
      end

      it "can graduate an AC", js: true do
        nonadmin = FactoryGirl.create(:user)
        id_selector = nonadmin.id
        sign_in admin_user

        visit users_path

        visit edit_user_path(nonadmin)
        page.find("#isac").trigger("click")
        fill_in "Program start date", with: "2014-07-08"
        page.find("#user_associate_consultant_attributes_graduated", visible: true).trigger("click")
        select reviewing_group.name, from: "Reviewing group"

        click_button "Save Changes"
        current_path.should eql users_path

        visit user_path(nonadmin)
        page.should have_selector("#isAC", text: 'Yes')
        page.should have_selector("#hasGraduated", text: 'Yes')

        visit users_path
        id_selector = nonadmin.email.slice(0..(nonadmin.email.index('@'))-1)
        page.should have_selector("tr##{id_selector} .fa-graduation-cap")
      end

      it "can make an ac" do
        nonadmin = FactoryGirl.create(:user)
        sign_in admin_user

        visit users_path

        visit edit_user_path(nonadmin)
        page.find("#isac").trigger('click')
        fill_in "Program start date", with: "2014-07-08"
        select reviewing_group.name, from: "Reviewing group"

        click_button "Save Changes"
        page.should have_selector('.flash-success', text: 'User "'+ nonadmin.name + '" was successfully updated and reviews created')
        current_path.should eql users_path

        visit user_path(nonadmin)
        page.should have_selector("#isAC", text: 'Yes')
        page.should have_selector("#program-start-date", text: "Jul. 08, 2014")
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
          click_button "Change User"
        end
        visit new_user_path
      }

      it "re-renders page with error message if invalid information" do
        click_button "Create Account"
        page.should have_selector('h1', text: 'Create an Account')
        page.should have_content("can't be blank")
      end

      it "creates an account and sends an email" do

        fill_in "Name", with: "Bob Smith"
        fill_in "Email", with: "test@example.com"
        click_button 'Create Account'

        current_path.should eql root_path
        page.should have_selector('.flash-success', text: 'User "Bob Smith" was successfully created')

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
        click_button 'Create'

        current_path.should eql users_path
        page.should have_selector('.flash-success', text: 'User "Bob Smith" was successfully created.')

        ActionMailer::Base.deliveries.length.should == 1
        mail = ActionMailer::Base.deliveries.last
        mail.to.should == ["test@example.com"]
        mail.subject.should == "[ReviewSite] You were registered!"

        new_user = User.last
        new_user.name.should == "Bob Smith"
        new_user.email.should == "test@example.com"
      end

      it "creates an ac account", js: true do
        fill_in "Name", with: "Roberto Glob"
        fill_in "Email", with: "test2@example.com"
        fill_in "Okta name", with: "glob"

        page.should have_selector("#user_associate_consultant_attributes_graduated", visible: false)
        page.find('#isac').trigger('click')
        page.should have_selector("#user_associate_consultant_attributes_graduated", visible: true)

        fill_in "Program start date", with: "2014-07-08"
        fill_in "Notes", with: "Here are some notes"
        select reviewing_group.name, from: "Reviewing group"
        find("#token-input-user_associate_consultant_attributes_coach_id").set(coach.id)

        click_button 'Create'

        current_path.should eql users_path
        page.should have_selector('.flash-success', text: 'User "Roberto Glob" was successfully created with 6-Month, 12-Month, 18-Month, and 24-Month reviews.')

        new_user = User.last
        new_user.associate_consultant.reviews.size.should == 4
        id_selector = new_user.email.slice(0..(new_user.email.index('@'))-1)
        page.should have_selector("tr##{id_selector} .fa-book")

        visit user_path(new_user)

        new_ac = new_user.associate_consultant
        page.should have_selector("#isAC", text: 'Yes')
        page.should have_selector("#hasGraduated", text: 'No')
        page.should have_selector("#notes", text: new_ac.notes)
        page.should have_selector("#reviewing-group", text: new_ac.reviewing_group)
      end
    end

    describe "as a non-admin user" do

      it "cannot create new users" do
        sign_in FactoryGirl.create(:user)
        visit new_user_path
        current_path.should == root_path
        page.should have_selector('.flash-alert', text: "You are not authorized to access this page.")
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
      it { should have_content("Admin No") }

      it "links to edit page" do
        click_link "Edit"
        current_path.should == edit_user_path(user)
      end

      it "links to users index page" do
        page.find(".diet.button", text: "Manage Users").click
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
        page.should have_selector('.flash-alert', text: 'You are not authorized to access this page.')
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

      it "has user fields displayed in table", js:true do
        should have_selector('td', text: 'Andy')
        should have_selector('td', text: 'andy@example.com')
        should have_selector('td', text: admin.name)
        should have_selector('td', text: admin.email)
      end

      it "should link to new" do
        click_link "New User"
        current_path.should == new_user_path
      end

      it "should link to show", js: true do
        within(:xpath, '//tr[contains(.//td/text(), "Andy")]') do
          page.find(".fa-eye").click
          current_path.should == user_path(user)
        end
      end

      it "should link to edit", js: true do
        within(:xpath, '//tr[contains(.//td/text(), "Andy")]') do
          page.find(".fa-pencil").click
          current_path.should == edit_user_path(user)
        end
      end

      it "should link to destroy", js: true do
        page.evaluate_script('window.confirm = function() { return true; }')
        within(:xpath, '//tr[contains(.//td/text(), "Andy")]') do
          page.find(".fa-trash").click
          current_path.should == users_path
        end
        page.should have_selector('.flash-success', text: 'User "Andy" was successfully deleted')
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
        page.should have_selector('.flash-alert', text: 'You are not authorized to access this page.')
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
        page.should have_selector('#feedbacks td', text: review.feedback_deadline.to_s(:short_date))
        page.should have_selector('#feedbacks td', text: feedback.updated_at.to_s(:short_date))
        page.should have_selector('#feedbacks td .fa-pencil')
        page.find(".fa-pencil").click
        current_path.should == edit_review_feedback_path(review, feedback)
      end


      it "displays the feedback with a 'View Feedback' action if submitted" do
        feedback.update_attribute(:submitted, true)
        visit completed_feedback_user_path(reviewer)

        page.should have_selector('#completeds td', text: ac.user.name)
        page.should have_selector('#completeds td', text: review.review_type)
        page.should have_selector('#completeds td', text: feedback.project_worked_on)
        page.should have_selector('#completeds td', text: feedback.updated_at.to_date.to_s(:short_date))
        page.should have_selector('#completeds td .fa-eye')
        page.find(".fa-eye").click
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
        page.should have_selector('.flash-alert', text: 'You are not authorized to access this page.')
      end
    end
  end
end
