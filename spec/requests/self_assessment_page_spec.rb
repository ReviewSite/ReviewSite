require 'spec_helper'

describe "Self assessment page" do
  let (:coach_user) { FactoryGirl.create(:user) }
  let (:jc_user) { FactoryGirl.create(:user) }
  let (:jc) { FactoryGirl.create(:junior_consultant, email: jc_user.email, coach: coach_user) }
  let (:review) { FactoryGirl.create(:review, junior_consultant: jc) }
  let (:feedback) { FactoryGirl.create(:feedback) }

  subject { page }

  describe "As a JC" do
    before { sign_in jc_user }

    describe "Creating self assessment" do  
      it "lets JC create a self assessment if one hasn't been created" do
        visit summary_review_path(review)
        page.should_not have_link('Update Self Assessment')
        click_link('Submit Self Assessment')
        
        current_path.should == new_review_self_assessment_path(review)
        fill_in 'Response', with: 'This is a self-assessment.'
        click_button 'Create Self assessment'

        current_path.should == summary_review_path(review)
        page.should_not have_link('Submit Self Assessment')
        page.should have_link('Update Self Assessment')
        page.should have_content('This is a self-assessment.')
      end
    end

    describe "Editing self assessment" do
      let! (:self_assessment) { FactoryGirl.create(:self_assessment, review: review, junior_consultant: jc) }

      it "lets JC edit their self assessment" do
        visit summary_review_path(review) 
        click_link('Update Self Assessment')

        current_path.should == edit_review_self_assessment_path(review, self_assessment)
        page.should have_selector('textarea#self_assessment_response',
                                    text: 'These are some notes that I have written')
        fill_in 'Response', with: 'Now I have edited my self-assessment.'
        click_button 'Update Self assessment'

        current_path.should == summary_review_path(review)
        page.should have_content('Now I have edited my self-assessment.')
      end
    end
  end

  describe "As a coach" do
    let! (:self_assessment) { FactoryGirl.create(:self_assessment, review: review, junior_consultant: jc) }

    before { sign_in coach_user }

    it "shows coach the self-assessment on the review summary page" do
      visit summary_review_path(review)
      page.should_not have_link('Update Self Assessment')
      page.should_not have_link('Submit Self Assessment')
      page.should have_content('These are some notes that I have written')
    end

    it "forbids coach from editing users' self assessments" do
      sign_in coach_user
      visit edit_review_self_assessment_path(review, self_assessment)
      current_path.should == root_path
      page.should have_selector('div.alert.alert-alert', text: 'You are not authorized to access this page.')
    end
  end
end