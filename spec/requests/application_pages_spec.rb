require 'spec_helper'

describe 'URL Access:' do
  let (:user) { FactoryGirl.create(:user) }

  subject { page }

  describe "users.json file" do
    it "redirects to root_url" do
      sign_in user
      visit root_url + "users.json"
      current_path.should == root_path
    end

    it "displays an error message" do
      sign_in user
      visit root_url + "users.json"
      subject.should have_selector('div.alert.alert-alert',
      text:"You are not authorized to access this page.")
    end
  end

  describe "associate_consultants.json file" do
    it "redirects to root_url" do
      sign_in user
      visit root_url + "associate_consultants.json"
      current_path.should == root_path
    end

    it "displays an error message" do
      sign_in user
      visit root_url + "associate_consultants.json"
      subject.should have_selector('div.alert.alert-alert',
      text:"You are not authorized to access this page.")
    end
  end
end
