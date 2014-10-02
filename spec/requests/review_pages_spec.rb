require 'spec_helper'

describe "Review pages" do
  let(:admin) { FactoryGirl.create(:admin_user) }
  let(:coach) { FactoryGirl.create(:user) }
  let(:reviewer) { FactoryGirl.create(:user) }
  let(:ac_user) { FactoryGirl.create(:user) }
  let(:ac) { FactoryGirl.create(:associate_consultant, coach: coach, :user => ac_user) }
  let!(:review) { FactoryGirl.create(:review, associate_consultant: ac) }
  let(:feedback) { FactoryGirl.create(:submitted_feedback, review: review, user: reviewer, created_at: Time.now-2.days) }
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
    let!(:self_assessment) { FactoryGirl.create(:self_assessment, associate_consultant: ac, review: review,
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
      end

      it "links to additional feedback" do
        click_link "Add Additional Feedback"
        current_path.should == additional_review_feedbacks_path(review)
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
    end

    describe "as a ac" do
      before do
        sign_in ac.user
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

      it "should derp" do
        expect{ click_link "export_to_excel" }.not_to raise_error
      end


    end

    describe "as a ac with a long name" do
      let(:long_name_user) { FactoryGirl.create(:user, name: "aaaaa bbbbb ccccc ddddd eeeee ff") }
      let(:long_name_ac) { FactoryGirl.create(:associate_consultant, :user => long_name_user) }
      let!(:long_name_review) { FactoryGirl.create(:review, associate_consultant: long_name_ac) }
      let!(:long_name_feedback) { FactoryGirl.create(:feedback, review: review, submitted: true) }

      before do
        sign_in long_name_ac.user
        visit summary_review_path(long_name_review)
      end

      it "should export to excel without raising an error" do
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

  describe "new" do
    describe "as an admin" do
      before do
        sign_in admin
        visit new_review_path

        unique_user = FactoryGirl.create(:user)
        @unique_ac = FactoryGirl.create(:associate_consultant, :user => unique_user)
      end

      it "creates a new review" do
        review = FactoryGirl.create(:review)

        fill_in 'review_associate_consultant_id', with: @unique_ac.id
        select "24-Month", from: "Review type"

        fill_in "review_review_date", with: "07/01/2014"
        fill_in "review_feedback_deadline", with: "21/06/2014"

        UserMailer.should_receive(:review_creation).and_return(double(deliver: true))
        click_button "Create Review"

        new_review = Review.last
        current_path.should == review_path(new_review)

        page.should have_selector('h2', text: new_review.review_type.titleize)
        page.should have_selector('h3', text: new_review.feedback_deadline)
        page.should have_selector('h3', text: new_review.review_date)
      end
    end

    describe "as a non-admin" do
      before do
        sign_in FactoryGirl.create(:user)
        visit new_review_path
      end

       it "redirects to homepage" do
        current_path.should == root_path
        page.should have_selector('div.alert.alert-alert', text: 'You are not authorized to access this page.')
       end
    end
  end

  describe "edit" do
    describe "as an admin" do
      before do
        sign_in admin
        visit edit_review_path(review)
      end

      it "updates the review details" do
        select "24-Month", from: "Review type"

        fill_in "review_review_date", with: "2013-01-07"
        fill_in "review_feedback_deadline", with: "2013-06-21"

        click_button "Save Changes"

        current_path.should == review_path(review)
        review.reload
        review.review_type.should == "24-Month"
        review.review_date.should == Date.new(2013, 1, 7)
        review.feedback_deadline.should == Date.new(2013, 06, 21)
      end
    end

    describe "as a non-admin" do
      before do
        sign_in FactoryGirl.create(:user)
        visit edit_review_path(review)
      end

       it "redirects to homepage" do
        current_path.should == root_path
        page.should have_selector('div.alert.alert-alert', text: 'You are not authorized to access this page.')
       end
    end
  end

  describe "show" do
    describe "as an admin" do
      before do
        sign_in admin
        feedback.update_attribute(:project_worked_on, inputs['project_worked_on'])
        visit review_path(review)
      end

      it { should have_selector('h2', text: review.review_type.titleize) }
      it { should have_selector('th', text: 'Reviewer') }
      it { should have_selector('th', text: 'Project') }
      it { should have_selector('th', text: 'Date Updated') }
      it { should have_selector('th', text: 'Status')}
      it { should have_selector('td', text: reviewer.name) }
      it { should have_selector('td', text: inputs['project_worked_on']) }
      it { should have_selector('td', text: feedback.updated_at.to_date.to_s) }
      it { should have_selector('td', text: 'Submitted') }
      it { should_not have_selector('td', text: 'Not') }

      it "links to show feedback" do
        click_link "Show"
        current_path.should == review_feedback_path(review, feedback)
      end

      # it "links to edit feedback" do
      #   click_link "feedback_#{feedback.id}_edit"
      #   current_path.should == edit_review_feedback_path(review, feedback)
      # end

      it "links to invite reviewer" do
        click_link "Request Feedback"
        current_path.should == new_review_invitation_path(review)
      end

   #   it "links to new feedback" do
   #     click_link "New Feedback"
#  #     current_path.should == new_review_feedback_path(review)
   #     current_path.should == root_path
   #   end

      it "links to additional feedback" do
        click_link "Additional Feedback"
        current_path.should == additional_review_feedbacks_path(review)
      end

      it "links to view summary" do
        click_link "View Summary"
        current_path.should == summary_review_path(review)
      end

      it "links to edit review" do
        click_link "review_edit"
        current_path.should == edit_review_path(review)
      end

      it "links to destroy review", js: true do
        click_link "review_destroy"
        page.evaluate_script("window.confirm = function() { return true; }")
        current_path.should == root_path
        Review.find_by_id(review).should be_nil
      end

    end

    describe "as a non-admin" do
      before do
        sign_in FactoryGirl.create(:user)
        visit review_path(review)
      end

       it "redirects to homepage" do
        current_path.should == root_path
        page.should have_selector('div.alert.alert-alert', text: 'You are not authorized to access this page.')
       end
    end
  end

  describe "send email" do
    it "when 'send email' link is clicked", js: true do
      sign_in admin
      visit root_path

      UserMailer.should_receive(:review_creation).with(review).and_return(double(deliver: true))
      click_link "Email Review Info"
      current_path.should == root_path
      page.should have_selector('div.alert.alert-success', text: 'An email with the details of the review was sent!')
    end

  end

end
