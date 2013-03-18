require 'spec_helper'

describe "Feedback pages" do
  describe "Submitting feedback", js: true do
    let(:user) { FactoryGirl.create(:admin_user) }
    let(:jc) { FactoryGirl.create(:junior_consultant) }
    let(:review) { FactoryGirl.create(:review, junior_consultant: jc) }
    subject { page }

    before do
      sign_in user
      visit (new_review_feedback_path(review))
      fill_in 'feedback_project_worked_on', with: 'Project X'
    end

    it "should redirect to feedback show page" do
      click_button 'Submit Final'
      page.evaluate_script("window.confirm = function() { return true; }")
      page.should have_selector('h1', text: 'Feedback Details')
      page.should have_content('Project X')
    end

    it "should send an email notification" do
      UserMailer.should_receive(:new_feedback_notification).and_return(double(deliver: true))
      click_button 'Submit Final'
      page.evaluate_script("window.confirm = function() { return true; }")
    end

    it "should send notification for previously-saved feedback" do
      UserMailer.should_receive(:new_feedback_notification).and_return(double(deliver: true))
      click_button 'Save Feedback'
      click_button 'Submit Final'
      page.evaluate_script("window.confirm = function() { return true; }")
      page.should have_content('The feedback was saved!')
    end
  end
end
