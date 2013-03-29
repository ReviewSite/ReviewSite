require 'spec_helper'

describe "Junior consultant pages" do
  describe "index" do
    let(:coach) { FactoryGirl.create(:user, name: 'Alice') }
    let!(:jc) { FactoryGirl.create(:junior_consultant, coach: coach) }
    subject { page }

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
end