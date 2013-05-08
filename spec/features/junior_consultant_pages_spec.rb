require 'spec_helper'

describe "Junior consultant pages" do
  subject { page }

  describe "index" do
    let(:coach) { FactoryGirl.create(:user, name: 'Alice') }
    let!(:jc) { FactoryGirl.create(:junior_consultant, coach: coach) }

    describe "as an admin" do
      before do
        sign_in FactoryGirl.create(:admin_user)
        visit junior_consultants_path
      end

      it { should have_selector('h1', text: 'Junior Consultants') }
      it { should have_selector('th', text: 'Name') }
      it { should have_selector('th', text: 'Email') }
      it { should have_selector('th', text: 'Notes') }
      it { should have_selector('th', text: 'Coach') }

      it { should have_selector('td', text: jc.name) }
      it { should have_selector('td', text: jc.email) }
      it { should have_selector('td', text: jc.notes) }
      it { should have_selector('td a', text: coach.name) }

      it "should link to new junior consultant" do
        click_link "New Junior consultant"
        current_path.should == new_junior_consultant_path
      end

      it "should link to coach's user page" do
        click_link coach.name
        current_path.should == user_path(coach)
      end

      it "should link to edit junior consultant" do
        click_link "Edit"
        current_path.should == edit_junior_consultant_path(jc)
      end

      it "should link to destroy junior consultant", js: true do
        click_link "Destroy"
        page.evaluate_script("window.confirm = function() { return true; }")
        current_path.should == junior_consultants_path
        page.should_not have_selector('td', text: jc.name)
        page.should_not have_selector('td', text: jc.email)
        page.should_not have_selector('td', text: jc.notes)
        page.should_not have_selector('td a', text: coach.name)
      end

      it "displays a message if a jc has no coach" do
        jc.destroy
        jc = FactoryGirl.create(:junior_consultant, coach: nil)
        visit junior_consultants_path
        page.should have_selector('td', text: "No coach assigned!")
      end
    end

    describe "as a non-admin" do
      before do
        sign_in FactoryGirl.create(:user)
        visit junior_consultants_path
      end

      it "is inaccessible" do
        current_path.should == root_path
        page.should have_selector('div.alert.alert-alert', text: 'You are not authorized to access this page.')
      end
    end
  end

  describe "new" do
    describe "as an admin" do
      let!(:coach) { FactoryGirl.create(:user, name: "The Coach") }
      let!(:user) { FactoryGirl.create(:user, name: "The Junior Consultant") }
      let!(:reviewing_group) { FactoryGirl.create(:reviewing_group) }

      before do
        sign_in FactoryGirl.create(:admin_user)
        visit new_junior_consultant_path
      end

      it "creates a junior consultant with the specified properties" do
        fill_in "Name", with: "Bob Smith"
        fill_in "Email", with: "test@example.com"
        fill_in "Notes", with: "This is a note."
        select reviewing_group.name, from: "Reviewing group"
        select coach.name, from: "Coach"
        select user.name, from: "User"
        click_button "Create Junior consultant"

        current_path.should == junior_consultants_path

        new_jc = JuniorConsultant.last
        new_jc.name.should == "Bob Smith"
        new_jc.email.should == "test@example.com"
        new_jc.notes.should == "This is a note."
        new_jc.reviewing_group.should == reviewing_group
        new_jc.coach.should == coach
      end
    end

    describe "as a non-admin" do
      before do
        sign_in FactoryGirl.create(:user)
        visit new_junior_consultant_path
      end

      it "is inaccessible" do
        current_path.should == root_path
        page.should have_selector('div.alert.alert-alert', text: 'You are not authorized to access this page.')
      end
    end
  end

  describe "edit" do
    let(:coach) { FactoryGirl.create(:user) }
    let(:reviewing_group) { FactoryGirl.create(:reviewing_group) }
    let!(:jc) { FactoryGirl.create(:junior_consultant, coach: coach, reviewing_group: reviewing_group) }

    describe "as an admin" do
      before do
        sign_in FactoryGirl.create(:admin_user)
        visit edit_junior_consultant_path(jc)
      end
    
      it { should have_field("Name", with: jc.name) }
      it { should have_field("Email", with: jc.email) }
      it { should have_selector("textarea#junior_consultant_notes", text: jc.notes) }
      it { should have_select("Reviewing group", selected: reviewing_group.name) }
      it { should have_select("Coach", selected: coach.name) }

      it "lets you change a junior consultant's properties" do
        fill_in "Name", with: "Amy Jones"
        fill_in "Email", with: "test2@example.com"
        fill_in "Notes", with: "I've edited the note."
        select "Select a coach", from: "Coach"
        
        click_button "Update Junior consultant"
        current_path.should == junior_consultants_path

        jc.reload
        jc.name.should == "Amy Jones"
        jc.email.should  == "test2@example.com"
        jc.notes.should == "I've edited the note."
        jc.coach.should be_nil
      end
    end

    describe "as a non-admin" do
      before do
        sign_in FactoryGirl.create(:user)
        visit edit_junior_consultant_path(jc)
      end

      it "is inaccessible" do
        current_path.should == root_path
        page.should have_selector('div.alert.alert-alert', text: 'You are not authorized to access this page.')
      end
    end
  end
end