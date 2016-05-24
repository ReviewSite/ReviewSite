require 'spec_helper'

describe 'URL Access:' do
  let (:user) { create(:user) }

  subject { page }

  describe "users.json file" do
    it "redirects to root_path" do
      sign_in user
      visit root_path + "users/get_users.json"
      page.should have_content "You are not authorized to access this page!"
    end

    it "displays an error message" do
      sign_in user
      visit root_path + "users/get_users.json"
      page.should have_content "You are not authorized to access this page!"
    end
  end

  describe "associate_consultants.json file" do
    it "redirects to root_path" do
      sign_in user
      visit root_path + "associate_consultants.json"
      page.should have_content "You are not authorized to access this page!"
    end

    it "displays an error message" do
      sign_in user
      visit root_path + "associate_consultants.json"
      page.should have_content "You are not authorized to access this page!"
    end
  end
end
