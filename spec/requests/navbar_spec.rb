require 'spec_helper'

describe "Navbar" do
  subject { page }

  describe "as an admin" do
    let(:admin) { create(:admin_user) }
    before do
      sign_in admin
      visit root_path
    end

    it { should have_selector(".navigation", text: admin.name) }
    it { should_not have_selector(".navigation", text: "Sign In") }

    it "should link to reviewing group index page" do
      within(".navigation") do
        click_link "Reviewing Group"
      end
      current_path.should == reviewing_groups_path
    end

    it "should link to users index page" do
      within(".navigation") do
        click_link "Users"
      end
      current_path.should == users_path
    end

    it "should link to user settings page" do
      within(".navigation") do
        click_link "Update Profile"
      end
      current_path.should == edit_user_path(admin)
    end

    it "should link to homepage" do
      within(".navigation") do
        click_link "Review Site"
      end
      current_path.should == root_path
    end

    it "should link to homepage via site name" do
      within(".navigation") do
        click_link "Review Site"
      end
      current_path.should == root_path
    end
  end

  describe "as a normal user" do
    let(:user) { create(:user) }
    before do
      sign_in user
      visit root_path
    end

    it { should have_selector(".navigation", text: user.name) }
    it { should_not have_selector(".navigation", text: "Reviewing Group") }
    it { should_not have_selector(".navigation", text: "Users") }

    it "should link to feedbacks page" do
      within(".navigation") do
        click_link "Feedback Requests"
      end
      current_path.should == feedbacks_user_path(user)
    end

    it "should link to user settings page" do
      within(".navigation") do
        click_link "Update Profile"
      end
      current_path.should == edit_user_path(user)
    end

    it "should link to homepage" do
      within(".navigation") do
        click_link "Review Site"
      end
      current_path.should == root_path
    end

    it "should link to homepage via site name" do
      within(".navigation") do
        click_link "Review Site"
      end
      current_path.should == root_path
    end
  end

  describe "not signed in" do
    it { should_not have_selector(".navigation", text: "Reviewing Group") }
    it { should_not have_selector(".navigation", text: "Users") }
  end
end
