require 'spec_helper'

describe "Review pages" do
  let(:admin) { FactoryGirl.create(:admin_user) }
  let(:coach) { FactoryGirl.create(:user) }
  let(:reviewer) { FactoryGirl.create(:user) }
  let(:jc) { FactoryGirl.create(:junior_consultant, coach: coach) }
  let(:jc_user) { FactoryGirl.create(:user, email: jc.email) }
  let!(:review) { FactoryGirl.create(:review, junior_consultant: jc) }
  let(:feedback) { FactoryGirl.create(:submitted_feedback, review: review, user: reviewer) }
  let(:inputs) { {
    'project_worked_on' => 'My Project',
    'role_description' => 'My Role',
    'tech_exceeded' => 'Input 1',
    'tech_met' => 'Input 2',
    'tech_improve' => 'Input 3',
    'client_exceeded' => 'Input 4',
    'client_met' => 'Input 5',
    'client_improve' => 'Input 6',
    'ownership_exceeded' => 'Input 7',
    'ownership_met' => 'Input 8',
    'ownership_improve' => 'Input 9',
    'leadership_exceeded' => 'Input 10',
    'leadership_met' => 'Input 11',
    'leadership_improve' => 'Input 12',
    'teamwork_exceeded' => 'Input 13',
    'teamwork_met' => 'Input 14',
    'teamwork_improve' => 'Input 15',
    'attitude_exceeded' => 'Input 16',
    'attitude_met' => 'Input 17',
    'attitude_improve' => 'Input 18',
    'professionalism_exceeded' => 'Input 19',
    'professionalism_met' => 'Input 20',
    'professionalism_improve' => 'Input 21',
    'organizational_exceeded' => 'Input 22',
    'organizational_met' => 'Input 23',
    'organizational_improve' => 'Input 24',
    'innovative_exceeded' => 'Input 25',
    'innovative_met' => 'Input 26',
    'innovative_improve' => 'Input 27',
    'comments' => 'My Comments'
  } }
  subject { page }

  describe "summary" do
    let!(:self_assessment) { FactoryGirl.create(:self_assessment, junior_consultant: jc, review: review,
                                              updated_at: DateTime.now-2.days) }
    before do
      inputs.each do |field, value|
        feedback.update_attribute(field, value)
      end
    end

    describe "as an admin" do
      before do
        sign_in admin
        visit summary_review_path(review)
      end

      it "displays feedback and self assessment" do
        page.should have_selector('h1', text: review.to_s)

        page.should have_content(Date.today)
        page.should have_content(reviewer.name)
        inputs.values do |value|
          page.should have_content(value)
        end

        page.should have_content(Date.today-2.days)
        page.should have_content(self_assessment.response)

        page.should_not have_selector('a', text: 'Update Self Assessment')
        page.should_not have_selector('a', text: 'Submit Self Assessment')
      end

      it "links to additional feedback" do
        click_link "Add Additional Feedback"
        current_path.should == additional_review_feedbacks_path(review)
      end
    end

    describe "as a jc" do
      before do
        sign_in jc_user
        visit summary_review_path(review)
      end

      it "displays feedback and self-assessment" do
        page.should have_selector('h1', text: review.to_s)

        page.should have_content(Date.today)
        page.should have_content(reviewer.name)
        inputs.values do |value|
          page.should have_content(value)
        end

        page.should have_content(Date.today-2.days)
        page.should have_content(self_assessment.response)
      end

      it "links to update self-assessment if one has been created" do
        page.should_not have_selector('a', text: 'Submit Self Assessment')
        click_link "Update Self Assessment"
        current_path.should == edit_review_self_assessment_path(review, self_assessment)
      end

      it "links to create self-assessment if none has been created" do
        self_assessment.destroy
        visit summary_review_path(review)
        page.should_not have_selector('a', text: 'Update Self Assessment')
        click_link "Submit Self Assessment"
        current_path.should == new_review_self_assessment_path(review)
      end

      it "links to additional feedback" do
        click_link "Add Additional Feedback"
        current_path.should == additional_review_feedbacks_path(review)
      end
    end

    describe "as a jc with a long name" do
      let(:long_name_jc) { FactoryGirl.create(:junior_consultant, name: "aaaaa bbbbb ccccc ddddd eeeee ff") }
      let!(:long_name_review) { FactoryGirl.create(:review, junior_consultant: long_name_jc) }
      let!(:long_name_feedback) { FactoryGirl.create(:feedback, review: review, submitted: true) }

      before do
        sign_in FactoryGirl.create(:user, email: long_name_jc.email)
      end

      it "should export to excel without raising an error" do
        visit summary_review_path(long_name_review)
        expect{ click_link "export_to_excel" }.not_to raise_error
      end
    end

    describe "as a coach" do
      before do
        sign_in coach
        visit summary_review_path(review)
      end

      it "displays feedback and self assessment" do
        page.should have_selector('h1', text: review.to_s)

        page.should have_content(Date.today)
        page.should have_content(reviewer.name)
        inputs.values do |value|
          page.should have_content(value)
        end

        page.should have_content(Date.today-2.days)
        page.should have_content(self_assessment.response)

        page.should_not have_selector('a', text: 'Update Self Assessment')
        page.should_not have_selector('a', text: 'Submit Self Assessment')
      end

      it "links to additional feedback" do
        click_link "Add Additional Feedback"
        current_path.should == additional_review_feedbacks_path(review)
      end
    end

    describe "as another user" do
      before do
        sign_in FactoryGirl.create(:user)
        visit summary_review_path(review)
      end

      it "redirects to homepage" do
        current_path.should == root_path
        page.should have_selector('div.alert.alert-alert', text: 'You are not authorized to access this page.')
      end
    end
  end
end