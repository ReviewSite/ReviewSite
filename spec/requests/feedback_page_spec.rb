require 'spec_helper'

describe "Submitting feedback", js: true do
  let(:user) { FactoryGirl.create(:user) }
  let(:jc) { FactoryGirl.create(:junior_consultant) }
  let(:review) { FactoryGirl.create(:review, junior_consultant: jc) }
  subject { page }

  before do
    sign_in user
    visit (new_review_feedback_path(review))
    fill_in 'feedback_project_worked_on', with: 'Project X'
  end

  it "should redirect and send notification" do
    UserMailer.should_receive(:new_feedback_notification).and_return(double(deliver: true))

    click_button 'Submit Final'
    page.evaluate_script("window.confirm = function() { return true; }")

    page.should have_selector('h1', text: 'Feedback Details')
    page.should have_content('Project X')
  end
end
