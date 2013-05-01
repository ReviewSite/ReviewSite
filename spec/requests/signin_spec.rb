require 'spec_helper'

describe "Signing in" do
  before do
    set_cas_user "jdoe"
  end

  describe "returning user with saved CAS name" do
    let!(:user) { FactoryGirl.create :user, name: "Jennifer Doe", cas_name: "jdoe" }

    it "should log the user in automatically" do
      visit root_path
      page.should have_content("Jennifer Doe")
      page.should have_content('Sign out')
      page.should_not have_content('Sign in')
    end
  end

  describe "returning user without saved CAS name" do
    let!(:user) { FactoryGirl.create :user, name: "Jennifer Doe", cas_name: nil }

    it "should redirect to the sign in page" do
      visit root_path
      current_path.should == signin_path
    end
  end
end