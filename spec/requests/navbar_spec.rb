require 'spec_helper'

describe "Navbar" do
  subject { page }

  describe "as an admin" do
    let(:admin) { FactoryGirl.create(:admin_user) }
    before do
      sign_in admin
      visit root_path
    end

    it { should have_selector(".navbar-fixed-top a", text: admin.name) }
    it { should_not have_selector(".navbar-fixed-top a", text: "Sign in") }

    it "should link to junior consultants index page" do
      within(".navbar-fixed-top") do
        click_link "Junior Consultants"
      end
      current_path.should == junior_consultants_path
    end

    it "should link to reviewing group index page" do
      within(".navbar-fixed-top") do
        click_link "Reviewing Group"
      end
      current_path.should == reviewing_groups_path
    end

    it "should link to reviewing group members index page" do
      within(".navbar-fixed-top") do
        click_link "Reviewing Group Members"
      end
      current_path.should == reviewing_group_members_path
    end

    it "should link to users index page" do
      within(".navbar-fixed-top") do
        click_link "Users"
      end
      current_path.should == users_path
    end

    it "should link to user settings page" do
      within(".navbar-fixed-top") do
        click_link "Settings"
      end
      current_path.should == edit_user_path(admin)
    end

    it "should link to sign out" do 
      within(".navbar-fixed-top") do
        click_link "Sign out"
      end
      current_path.should == root_path
      page.should have_selector(".navbar-fixed-top a", text: "Sign in")
      page.should_not have_selector(".navbar-fixed-top a", text: admin.name)
      page.should_not have_selector(".navbar-fixed-top a", text: "Sign out")
      page.should_not have_selector(".navbar-fixed-top a", text: "Settings")
      page.should_not have_selector(".navbar-fixed-top a", text: "Users")
      page.should_not have_selector(".navbar-fixed-top a", text: "Reviewing Group Members")
      page.should_not have_selector(".navbar-fixed-top a", text: "Reviewing Group")
      page.should_not have_selector(".navbar-fixed-top a", text: "Junior Consultants")
    end

    it "should link to homepage" do
      visit signin_path
      within(".navbar-fixed-top") do
        click_link "Home"
      end
      current_path.should == root_path
    end    

    it "should link to homepage via site name" do
      visit signin_path
      within(".navbar-fixed-top") do
        click_link "Review Website"
      end
      current_path.should == root_path
    end    
  end

  describe "as a normal user" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit root_path
    end

    it { should have_selector(".navbar-fixed-top a", text: user.name) }
    it { should_not have_selector(".navbar-fixed-top a", text: "Sign in") }
    it { should_not have_selector(".navbar-fixed-top a", text: "Junior Consultants") }
    it { should_not have_selector(".navbar-fixed-top a", text: "Reviewing Group") }
    it { should_not have_selector(".navbar-fixed-top a", text: "Reviewing Group Members") }
    it { should_not have_selector(".navbar-fixed-top a", text: "Users") }

    it "should link to feedbacks page" do
      within(".navbar-fixed-top") do
        click_link "Feedback From Me"
      end
      current_path.should == feedbacks_user_path(user)
    end

    it "should link to user settings page" do
      within(".navbar-fixed-top") do
        click_link "Settings"
      end
      current_path.should == edit_user_path(user)
    end

    it "should link to sign out" do 
      within(".navbar-fixed-top") do
        click_link "Sign out"
      end
      current_path.should == root_path
      page.should have_selector(".navbar-fixed-top a", text: "Sign in")
      page.should_not have_selector(".navbar-fixed-top a", text: user.name)
      page.should_not have_selector(".navbar-fixed-top a", text: "Sign out")
      page.should_not have_selector(".navbar-fixed-top a", text: "Settings")
    end

    it "should link to homepage" do
      visit signin_path
      within(".navbar-fixed-top") do
        click_link "Home"
      end
      current_path.should == root_path
    end    

    it "should link to homepage via site name" do
      visit signin_path
      within(".navbar-fixed-top") do
        click_link "Review Website"
      end
      current_path.should == root_path
    end    
  end

  describe "not signed in" do
    it { should_not have_selector(".navbar-fixed-top a", text: "Sign out") }
    it { should_not have_selector(".navbar-fixed-top a", text: "Settings") }
    it { should_not have_selector(".navbar-fixed-top a", text: "Junior Consultants") }
    it { should_not have_selector(".navbar-fixed-top a", text: "Reviewing Group") }
    it { should_not have_selector(".navbar-fixed-top a", text: "Reviewing Group Members") }
    it { should_not have_selector(".navbar-fixed-top a", text: "Users") }

    it "should link to signin page" do
      visit root_path
      within(".navbar-fixed-top") do
        click_link "Sign in"
      end
      current_path.should == signin_path
    end

    it "should link to homepage" do
      visit signin_path
      within(".navbar-fixed-top") do
        click_link "Home"
      end
      current_path.should == root_path
    end

    it "should link to homepage via site name" do
      visit signin_path
      within(".navbar-fixed-top") do
        click_link "Review Website"
      end
      current_path.should == root_path
    end
  end
end