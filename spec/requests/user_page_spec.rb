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

  describe "Creating a new user" do
    before { ActionMailer::Base.deliveries.clear }

    it "re-renders page with error message if invalid information" do
      visit new_user_path
      click_button "Create Account"
      page.should have_selector('h1', text: 'New user')
      page.should have_content('error')
    end

    it "allows people to create their own account" do
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
      mail.subject.should == "Thank you for registering on the ReviewSite"
      mail.body.encoded.should_not match("foobar")
    end

    it "includes password in email if admin creates a new user" do
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

    it "does not allow other logged-in users to create new users" do
      sign_in FactoryGirl.create(:user)
      visit new_user_path
      current_path.should == root_path
      page.should have_selector('div.alert.alert-alert', text: "You are not authorized to access this page.")
    end
  end
end
