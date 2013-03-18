require 'spec_helper'

describe "Home page" do
  let! (:jc) { FactoryGirl.create :junior_consultant }
  let! (:review) { FactoryGirl.create :review, junior_consultant: jc }

  subject { page }

  describe "as admin" do
    let (:admin) { FactoryGirl.create :admin_user }
    before { sign_in admin }

    it "can navigate to the reviewer invitation page" do
      click_link 'Invite Reviewer'
      page.should have_selector('h1', text: 'Invite Reviewer')
    end
  end

  describe "as JC" do
    let (:jc_user) { FactoryGirl.create :user, email: jc.email }
    before { sign_in jc_user }

    it "can navigate to the reviewer invitation page" do
      click_link 'Invite Reviewer'
      page.should have_selector('h1', text: 'Invite Reviewer')
    end
  end
end