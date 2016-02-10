require 'spec_helper'

describe "Self assessment page" do
  let (:admin) { create(:admin_user) }
  let! (:ac_user) { create(:user) }
  let! (:ac) { create(:associate_consultant, :user => ac_user) }
  let! (:review) { create(:review, associate_consultant: ac) }
  let (:feedback) { create(:feedback) }

  subject { page }

  describe "create" do
    describe "as an AC" do
      before do
        sign_in ac_user
        visit new_review_self_assessment_path(review)
      end

      it "lets AC create a self assessment" do
        fill_in 'Performance Assessment', with: 'This is a self-assessment.'

        click_button 'Submit'
        current_path.should == summary_review_path(review)

        self_assessment = SelfAssessment.last
        self_assessment.response.should == 'This is a self-assessment.'
        self_assessment.review.should == review
        self_assessment.associate_consultant.should == ac
      end
    end

    describe "as another user" do
      before do
        sign_in create(:user)
        visit new_review_self_assessment_path(review)
      end

      it "forbids coach from editing users' self assessments" do
        current_path.should == root_path
        page.should have_selector('.flash-alert', text: 'You are not authorized to access this page.')
      end
    end
  end

  describe "edit" do
    let! (:self_assessment) { create(:self_assessment, review: review, associate_consultant: ac) }

    describe "as an AC" do
      before do
        sign_in ac_user
        visit edit_review_self_assessment_path(review, self_assessment)
      end

      it "lets AC edit their self assessment" do
        page.should have_selector('textarea#self_assessment_response',
                                    text: 'These are some notes that I have written')
        fill_in 'Performance Assessment', with: 'Now I have edited my self-assessment.'

        click_button 'Save Changes'
        current_path.should == summary_review_path(review)

        self_assessment.reload
        self_assessment.response.should == 'Now I have edited my self-assessment.'
      end

      it "doesn't let ACs submit blank self assessments" do
        fill_in 'Performance Assessment', with: ''

        click_button 'Save Changes'
        current_path.should == review_self_assessment_path(review, self_assessment)

        page.should have_selector('div.field > p.field-error-message', text: 'can\'t be blank')
      end
    end

    describe "as another user" do
      before do
        sign_in create(:user)
        visit edit_review_self_assessment_path(review, self_assessment)
      end

      it "forbids coach from editing users' self assessments" do
        current_path.should == root_path
        page.should have_selector('.flash-alert', text: 'You are not authorized to access this page.')
      end
    end
  end
end
