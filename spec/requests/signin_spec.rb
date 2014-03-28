require 'spec_helper'

describe "Signing in" do
  before do
    sign_in double(cas_name: "jdoe")
  end

  describe "returning user with saved CAS name" do
    let!(:user) { FactoryGirl.create :user, name: "Jennifer Doe", cas_name: "jdoe" }

    it "should log the user in automatically" do
      visit root_path
      current_path.should == root_path
      page.should have_content("Jennifer Doe")
      page.should have_content('Sign out')
      page.should_not have_content('Sign in')
    end
  end

  describe "returning user without saved CAS name" do
    let!(:user) { FactoryGirl.create(:user, 
                                      name: "Jennifer Doe",
                                      email: "jdoe@thoughtworks.com",
                                      password_digest: BCrypt::Password.create('password') ) }

    before do
      user.stub(:password_digest) {  }
      user.update_attribute(:cas_name, nil)
    end

    it "should redirect to the sign up page" do
      visit root_path
      current_path.should == signup_path
    end

    it "should save CAS name after user logs in" do
      visit signin_path
      fill_in 'Email', with: 'jdoe@thoughtworks.com'
      fill_in 'Password', with: 'password'
      click_button 'Sign in'

      current_path.should == root_path
      page.should have_content("Jennifer Doe")
      page.should have_content('Sign out')
      page.should_not have_content('Sign in')
      page.should have_selector("div.alert", text: "From now on, we will sign you in automatically via CAS.")

      user.reload
      user.cas_name.should == 'jdoe'
    end
  end
end