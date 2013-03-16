require 'spec_helper'

describe "Home page" do
  let (:admin) { FactoryGirl.create :admin_user }
  let! (:jc) { FactoryGirl.create :junior_consultant }
  let! (:review) { FactoryGirl.create :review, junior_consultant: jc }

  subject { page }

  before do
    sign_in admin
  end

  it "can navigate to the reviewer invitation page" do
    click_link 'Invite Reviewer'
    page.should have_selector('h1', text: 'Invite Reviewer')
  end
end