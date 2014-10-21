require 'spec_helper'

describe "Self assessment page" do
  let (:admin) { FactoryGirl.create(:admin_user) }
  let (:ac_user) { FactoryGirl.create(:user) }
  let (:ac) { FactoryGirl.create(:associate_consultant, :user => ac_user) }
  let (:review) { FactoryGirl.create(:review, associate_consultant: ac) }
  let (:feedback) { FactoryGirl.create(:feedback) }

  subject { page }

  describe "create" do
    describe "as an AC" do
      before do
        sign_in ac_user
        visit new_review_self_assessment_path(review)
      end

      it "lets AC create a self assessment" do
        fill_in 'Response', with: 'This is a self-assessment.'
        click_button 'Submit Self Assessment'
        current_path.should == summary_review_path(review)

        self_assessment = SelfAssessment.last
        self_assessment.response.should == 'This is a self-assessment.'
        self_assessment.review.should == review
        self_assessment.associate_consultant.should == ac
      end
    end

    describe "as an admin" do
      before do
        sign_in admin
        visit new_review_self_assessment_path(review)
      end

      it "lets admin create a self assessment if one hasn't been created" do
        fill_in 'Response', with: 'This is a self-assessment.'
        click_button 'Submit Self Assessment'
        current_path.should == summary_review_path(review)

        self_assessment = SelfAssessment.last
        self_assessment.response.should == 'This is a self-assessment.'
        self_assessment.review.should == review
        self_assessment.associate_consultant.should == ac
      end
    end

    describe "as another user" do
      before do
        sign_in FactoryGirl.create(:user)
        visit new_review_self_assessment_path(review)
      end

      it "forbids coach from editing users' self assessments" do
        current_path.should == root_path
        page.should have_selector('.flash-alert', text: 'You are not authorized to access this page.')
      end
    end
  end

  describe "edit" do
    let! (:self_assessment) { FactoryGirl.create(:self_assessment, review: review, associate_consultant: ac) }

    describe "as an AC" do
      before do
        sign_in ac_user
        visit edit_review_self_assessment_path(review, self_assessment)
      end

      it "lets AC edit their self assessment" do
        page.should have_selector('textarea#self_assessment_response',
                                    text: 'These are some notes that I have written')
        fill_in 'Response', with: 'Now I have edited my self-assessment.'
        click_button 'Save Changes'
        current_path.should == summary_review_path(review)

        self_assessment.reload
        self_assessment.response.should == 'Now I have edited my self-assessment.'
      end
    end

    describe "as an admin" do
      before do
        sign_in admin
        visit edit_review_self_assessment_path(review, self_assessment)
      end

      it "lets admin edit an AC's self assessment" do
        page.should have_selector('textarea#self_assessment_response',
                                    text: 'These are some notes that I have written')
        fill_in 'Response', with: 'Now I have edited my self-assessment.'
        click_button 'Save Changes'
        current_path.should == summary_review_path(review)

        self_assessment.reload
        self_assessment.response.should == 'Now I have edited my self-assessment.'
      end
    end

    describe "as another user" do
      before do
        sign_in FactoryGirl.create(:user)
        visit edit_review_self_assessment_path(review, self_assessment)
      end

      it "forbids coach from editing users' self assessments" do
        current_path.should == root_path
        page.should have_selector('.flash-alert', text: 'You are not authorized to access this page.')
      end
    end
  end
end
