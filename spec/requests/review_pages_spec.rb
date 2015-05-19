require 'spec_helper'

describe "Review pages" do
  let(:admin) { create(:admin_user) }
  let(:coach) { create(:user) }
  let(:reviewer) { create(:user) }
  let(:ac_user) { create(:user) }
  let(:ac) { create(:associate_consultant, coach: coach, :user => ac_user) }
  let!(:review) { create(:review, associate_consultant: ac) }
  let(:review_with_invite) { create(:review, associate_consultant: ac, review_type: "6-Month") }
  let(:invite) { create(:invitation, review: review_with_invite, email: "example@thoughtworks.com") }
  let(:feedback) { create(:submitted_feedback, review: review, user: reviewer, created_at: Time.now-2.days) }
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
    let!(:self_assessment) { create(:self_assessment, associate_consultant: ac, review: review,
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
        page.should have_selector('h2', text: review.pretty_print_with(admin))

        page.should have_content(Date.today)
        page.should have_content(reviewer.name)
        inputs.values do |value|
          page.should have_content(value)
        end

        page.should have_content(Date.today-2.days)
        page.should have_content(self_assessment.response)
        page.click_link("export_to_excel")
        page.response_headers['Content-Type'].should eq 'application/vnd.'\
          'openxmlformats-officedocument.spreadsheetml.sheet; charset=utf-8'
      end
    end

    describe "as an ac" do
      before do
        sign_in ac.user
        visit summary_review_path(review)
      end

      it "displays feedback and self-assessment" do
        page.should have_selector('h2', text: review.pretty_print_with(ac.user))
        page.should have_content(Date.today)
        page.should have_content(reviewer.name)
        inputs.values do |value|
          page.should have_content(value)
        end

        page.should have_content(Date.today-2.days)
        page.should have_content(self_assessment.response)
      end

      it "exports to excel file" do
        expect{ click_link "export_to_excel" }.not_to raise_error
      end


    end

    describe "as a ac with a long name" do
      let(:long_name_user) { create(:user, name: "aaaaa bbbbb ccccc ddddd eeeee ff") }
      let(:long_name_ac) { create(:associate_consultant, :user => long_name_user) }
      let!(:long_name_review) { create(:review, associate_consultant: long_name_ac) }
      let!(:long_name_feedback) { create(:feedback, review: review, submitted: true) }

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
        page.should have_selector('h2', text: review.pretty_print_with(coach))

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
    end

    describe "as another user" do
      before do
        sign_in create(:user)
        visit summary_review_path(review)
      end

      it "redirects to homepage" do
        current_path.should == root_path
        page.should have_selector('.flash-alert', text: 'You are not authorized to access this page.')
      end
    end
  end

  describe "new" do
    describe "as an admin" do
      before do
        sign_in admin
        visit new_review_path

        unique_user = create(:user)
        @unique_ac = create(:associate_consultant, :user => unique_user)
      end

      it "creates a new review", js: true do
        review = create(:review)
        page.execute_script( " $('.datepicker').datepicker('remove'); " )
        page.find_by_id('review_associate_consultant_id', visible: false).
          set(@unique_ac.id)
        select "24-Month", from: "Review type"

        fill_in "review_review_date", with: "07/08/2014"
        page.find_by_id("review_feedback_deadline").value.should == "2014-7-1"
        fill_in "review_feedback_deadline", with: "21/06/2014"

        UserMailer.should_receive(:review_creation).and_return(double(deliver: true))
        click_button "Create"

        new_review = Review.last
        current_path.should == review_path(new_review)

        page.should have_selector('h1', text: new_review.review_type.upcase)
        page.should have_selector('h2', text: new_review.review_date.to_s(:short_date))
      end
    end

    describe "as a non-admin" do
      before do
        sign_in create(:user)
        visit new_review_path
      end

       it "redirects to homepage" do
        current_path.should == root_path
        page.should have_selector('.flash-alert', text: 'You are not authorized to access this page.')
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

        fill_in "review_review_date", with: "2020-06-07"
        fill_in "review_feedback_deadline", with: "2020-01-21"

        click_button "Save Changes"

        current_path.should == review_path(review)
        review.reload
        review.review_type.should == "24-Month"
        review.review_date.should == Date.new(2020, 6, 7)
        review.feedback_deadline.should == Date.new(2020, 01, 21)
      end
    end

    describe "as the reviewee" do
      before do
        sign_in ac.user
        visit edit_review_path(review)
      end

       it "shows the edit page" do
        current_path.should == edit_review_path(review)
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

      it { should have_selector('h1', text: review.review_type) }
      it { should have_selector('th', text: 'Reviewer') }
      it { should have_selector('th', text: 'Project') }
      it { should have_selector('th', text: 'Updated') }
      it { should have_selector('th', text: 'Status')}
      it { should have_selector('td', text: reviewer.name) }
      it { should have_selector('td', text: inputs['project_worked_on']) }
      it { should have_selector('td', text: feedback.updated_at.to_date.to_s(:short_date)) }
      it { should have_selector('td', text: 'Submitted') }
      it { should_not have_selector('td', text: 'Not') }

      it "links to show feedback" do
        page.find(".fa-eye").click
        current_path.should == review_feedback_path(review, feedback)
      end

      it "links to view summary" do
        click_link "Feedback Summary"
        current_path.should == summary_review_path(review)
      end

      it "links to edit review" do
        click_link "review-edit"
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
        sign_in create(:user)
        visit review_path(review)
      end

       it "redirects to homepage" do
        current_path.should == root_path
        page.should have_selector('.flash-alert', text: 'You are not authorized to access this page.')
       end
    end
  end

  describe "send email" do
    it "when 'send email' link is clicked", js: true do
      sign_in admin
      visit review_path(review)

      UserMailer.should_receive(:review_creation).with(review).and_return(double(deliver: true))
      click_link "Email Review Info"
      page.should have_selector('.flash-success', text: 'An email with the details of the review was sent!')
    end
  end

  describe "delete invitation" do
    let!(:invite) { create(:invitation, review: review) }

    describe "as an AC" do
      before do
        sign_in ac_user
        visit review_path(review)
      end

      it "links to delete an invitation" do
        page.find(".fa-trash").click
        current_path.should == root_path
        page.should have_selector('.flash-success', text: 'bob@thoughtworks.com\'s invitation has been deleted.')
      end
    end
  end

  describe "index" do
    let(:ac_with_old_review) { create(:associate_consultant)}
    let(:user_with_reviews) { create(:user,
      email: "testestest@thoughtworks.com") }
    let!(:ac_with_four_reviews) { create(:associate_consultant,
      user: user_with_reviews, graduated: true) }

    describe "as an ac" do
      before do
        create(:review, associate_consultant: ac_with_old_review,
          review_type: "6-Month", review_date: Date.today - 6.months, feedback_deadline: Date.today - 7.months)
        create(:review, associate_consultant: ac_with_old_review,
          review_type: "12-Month")
        sign_in ac_with_old_review.user
        visit reviews_path
      end

      it "should be able to see old reviews" do
        page.all("tr", text:"6-Month").first.should have_selector(".fa-eye")
      end
    end

    describe "as a graduated ac" do
      before do
        create(:review, associate_consultant: ac_with_four_reviews,
          review_type: "6-Month")
        create(:review, associate_consultant: ac_with_four_reviews,
          review_type: "12-Month")
        create(:review, associate_consultant: ac_with_four_reviews,
          review_type: "18-Month")
        create(:review, associate_consultant: ac_with_four_reviews,
          review_type: "24-Month")
        sign_in ac_with_four_reviews.user
        visit reviews_path
      end

      it "should show ac's review table" do
        page.should have_selector('h1', text: 'My Reviews')
      end

      it "should show ac's reviews", js: true do
        page.all("tr", text: "Month").count.should == 4
      end

      describe "who's also a coach" do
        let(:coachee) { create(:associate_consultant,
          coach: ac_with_four_reviews.user) }

          before do
            create(:review, associate_consultant: coachee,
              review_type: "6-Month")
            create(:review, associate_consultant: coachee,
              review_type: "12-Month")
              visit coachees_reviews_path
          end

        it "should show the coachee(s)' review table" do
          page.should have_selector('h1', text: "My Coachees' Reviews")
        end

        it "should show the coachee's reviews", js: true do
          page.all('tr', text: "#{coachee.user.name}").count.should == 2
        end
      end
    end
  end
end
