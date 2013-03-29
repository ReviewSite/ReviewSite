require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "edit" do
    let(:user) {User.new(:name => "Aleksandar Serafimoski",:email => "as438370@loras.edu",:password => "sase1590",:password_confirmation => "sase1590")}
    before do
      user.save
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title', text: "Edit user") }
    end

    describe "with valid information" do

      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }

      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Password confirmation", with: user.password
        click_button "Save changes"
      end

      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }
      it { should have_content('error') }
    end
  end

  describe "new" do
    before { ActionMailer::Base.deliveries.clear }

    describe "as a new user" do
      before { visit new_user_path }

      it "re-renders page with error message if invalid information" do
        click_button "Create Account"
        page.should have_selector('h1', text: 'New user')
        page.should have_content('error')
      end

      it "creates an account and sends an email with no password" do
        fill_in "Name", with: "Bob Smith"
        fill_in "Email", with: "test@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Password confirmation", with: "foobar"
        click_button 'Create Account'

        current_path.should == root_path
        page.should have_selector('div.alert.alert-success', text: 'User has been successfully created.')

        ActionMailer::Base.deliveries.length.should == 1
        mail = ActionMailer::Base.deliveries.last
        mail.to.should == ["test@example.com"]
        mail.subject.should == "Thank you for registering on the ReviewSite"
        mail.body.encoded.should_not match("foobar")
      end
    end

    describe "as an admin" do
      it "creates an account and sends an email with a password" do
        sign_in FactoryGirl.create(:admin_user)
        visit new_user_path
        fill_in "Name", with: "Bob Smith"
        fill_in "Email", with: "test@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Password confirmation", with: "foobar"
        click_button 'Create Account'

        current_path.should == root_path
        page.should have_selector('div.alert.alert-success', text: 'User has been successfully created.')

        ActionMailer::Base.deliveries.length.should == 1
        mail = ActionMailer::Base.deliveries.last
        mail.to.should == ["test@example.com"]
        mail.subject.should == "You were registered on the ReviewSite"
        mail.body.encoded.should match("foobar")
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

      it { should have_selector('h1', text: 'Listing users') }
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
        click_link "Show"
        current_path.should == user_path(user)
      end

      it "should link to edit" do
        click_link "Edit"
        current_path.should == edit_user_path(user)
      end

      it "should link to destroy", js: true do
        click_link "Destroy"
        page.evaluate_script("window.confirm = function() { return true; }")
        current_path.should == users_path
        page.should have_selector('div.alert.alert-success', text: 'User destroyed.')
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
end
