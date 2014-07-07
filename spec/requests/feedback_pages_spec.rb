require 'spec_helper'

describe "Feedback pages", :type => :feature do
  let(:jc_user) { FactoryGirl.create(:user) }
  let(:jc) { FactoryGirl.create(:junior_consultant, :user => jc_user) }
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin_user) }
  let(:review) { FactoryGirl.create(:review, junior_consultant: jc) }
  let(:inputs) { {
    'feedback_project_worked_on' => 'My Project',
    'feedback_role_description' => 'My Role',
    'feedback_tech_exceeded' => 'Input 1',
    'feedback_tech_met' => 'Input 2',
    'feedback_tech_improve' => 'Input 3',
    # The rest of these are not visible (hidden in the accordion)
    #'feedback_client_exceeded' => 'Input 4',
    #'feedback_client_met' => 'Input 5',
    #'feedback_client_improve' => 'Input 6',
    #'feedback_ownership_exceeded' => 'Input 7',
    #'feedback_ownership_met' => 'Input 8',
    #'feedback_ownership_improve' => 'Input 9',
    #'feedback_leadership_exceeded' => 'Input 10',
    #'feedback_leadership_met' => 'Input 11',
    #'feedback_leadership_improve' => 'Input 12',
    #'feedback_teamwork_exceeded' => 'Input 13',
    #'feedback_teamwork_met' => 'Input 14',
    #'feedback_teamwork_improve' => 'Input 15',
    #'feedback_attitude_exceeded' => 'Input 16',
    #'feedback_attitude_met' => 'Input 17',
    #'feedback_attitude_improve' => 'Input 18',
    #'feedback_professionalism_exceeded' => 'Input 19',
    #'feedback_professionalism_met' => 'Input 20',
    #'feedback_professionalism_improve' => 'Input 21',
    #'feedback_organizational_exceeded' => 'Input 22',
    #'feedback_organizational_met' => 'Input 23',
    #'feedback_organizational_improve' => 'Input 24',
    #'feedback_innovative_exceeded' => 'Input 25',
    #'feedback_innovative_met' => 'Input 26',
    #'feedback_innovative_improve' => 'Input 27',
    #'feedback_comments' => 'My Comments'
  } }

  subject { page }

  describe "new", :type => :feature do
    before do
      sign_in user
    end

    describe "if no existing feedback", :type => :feature do
      before do
        visit new_review_feedback_path(review)
        inputs.each do |field, value|
          fill_in field, with: value
        end
      end

      it "saves as draft if 'Save Feedback' is clicked" do
        #click_button "Save Feedback"
        first(:button, "Save Feedback").click
        feedback = Feedback.last
        current_path.should == edit_review_feedback_path(review, feedback)
        feedback.submitted.should be_false

        inputs.each do |field, value|
          model_attr = field[9..-1]
          feedback.send(model_attr).should == value
        end
      end

      it "saves as final and sends email if 'Submit Final' is clicked", js: true do
        ActionMailer::Base.deliveries.clear

        page.evaluate_script('window.confirm = function() { return true; }')
        click_button "Submit Final"
        find(".alert-notice") # wait for the resulting page to load

        feedback = Feedback.last
        current_path.should == review_feedback_path(review, feedback)
        feedback.submitted.should be_true

        inputs.each do |field, value|
          model_attr = field[9..-1]
          feedback.send(model_attr).should == value
        end

        ActionMailer::Base.deliveries.length.should == 1
        mail = ActionMailer::Base.deliveries.last
        mail.to.should == [jc.user.email]
        mail.subject.should == "[ReviewSite] You have new feedback from #{feedback.user}"
      end
    end
  end

  describe "edit" do
    let(:feedback) { FactoryGirl.create(:feedback, review: review, user: user) }

    describe "as feedback owner" do
      before do
        sign_in user
      end

      describe "if feedback has been saved as draft" do
        before do
          inputs.each do |field, value|
            model_attr = field[9..-1]
            feedback.update_attribute(model_attr, value)
          end
          visit edit_review_feedback_path(review, feedback)
        end

        it "reloads saved feedback" do
          inputs.each do |field, value|
            if ['feedback_project_worked_on', 'feedback_role_description'].include?(field)
              page.should have_field(field, with: value)
            else
              page.should have_selector('#'+field, text: value)
            end
          end
        end

        it "saves as draft if 'Save Feedback' is clicked" do
          inputs.each do |field, value|
            fill_in field, with: ""
          end

          first(:button, "Save Feedback").click
          feedback = Feedback.last
          current_path.should == edit_review_feedback_path(review, feedback)
          feedback.submitted.should be_false

          inputs.each do |field, value|
            model_attr = field[9..-1]
            feedback.send(model_attr).should == ""
          end
        end

        it "saves as final if 'Submit Final' is clicked", js: true do
          ActionMailer::Base.deliveries.clear

          inputs.each do |field, value|
            fill_in field, with: ""
          end

          page.evaluate_script('window.confirm = function() { return true; }')
          click_button "Submit Final"
          find(".alert-notice") # wait for the resulting page to load

          feedback = Feedback.last
          current_path.should == review_feedback_path(review, feedback)
          feedback.submitted.should be_true

          inputs.each do |field, value|
            model_attr = field[9..-1]
            feedback.send(model_attr).should == ""
          end

          ActionMailer::Base.deliveries.length.should == 1
          mail = ActionMailer::Base.deliveries.last
          mail.to.should == [jc.user.email]
          mail.subject.should == "[ReviewSite] You have new feedback from #{feedback.user}"
        end
      end

      describe "if feedback has been submitted" do
        before do
          feedback.update_attribute(:submitted, true)
          visit edit_review_feedback_path(review, feedback)
        end

        it "should redirect to homepage" do
          current_path.should == root_path
          page.should have_selector('div.alert.alert-alert', text:"You are not authorized to access this page.")
        end
      end
    end

    describe "as other user" do
      before do
        sign_in FactoryGirl.create(:user)
        visit edit_review_feedback_path(review, feedback)
      end

      it "should redirect to homepage" do
        current_path.should == root_path
        page.should have_selector('div.alert.alert-alert', text:"You are not authorized to access this page.")
      end
    end
  end

  describe "additional" do
    before do
      sign_in FactoryGirl.create(:user)
      visit additional_review_feedbacks_path(review)
      fill_in "feedback_user_string", with: "A non-user"
      inputs.each do |field, value|
        fill_in field, with: value
      end
    end

    it "saves as draft if 'Save Feedback' is clicked" do
      #click_button "Save Feedback"
      first(:button, "Save Feedback").click
      feedback = Feedback.last
      current_path.should == edit_review_feedback_path(review, feedback)
      feedback.submitted.should be_false
      feedback.user_string.should == "A non-user"
      inputs.each do |field, value|
        model_attr = field[9..-1]
        feedback.send(model_attr).should == value
      end
    end

    it "saves as final and sends email if 'Submit Final' is clicked", js: true do
      ActionMailer::Base.deliveries.clear

      page.evaluate_script('window.confirm = function() { return true; }')
      click_button "Submit Final"
      find(".alert-notice") # wait for the resulting page to load

      feedback = Feedback.last
      current_path.should == review_feedback_path(review, feedback)
      feedback.submitted.should be_true
      feedback.user_string.should == "A non-user"
      inputs.each do |field, value|
        model_attr = field[9..-1]
        feedback.send(model_attr).should == value
      end

      ActionMailer::Base.deliveries.length.should == 1
      mail = ActionMailer::Base.deliveries.last
      mail.to.should == [jc.user.email]
      mail.subject.should == "[ReviewSite] You have new feedback from #{feedback.user}"
    end
  end

  describe "show" do
    let(:feedback) { FactoryGirl.create(:feedback, review: review, user: user) }

    before do
      inputs.each do |field, value|
        model_attr = field[9..-1]
        feedback.update_attribute(model_attr, value)
      end
    end

    describe "unsubmitted feedback" do
      describe "as feedback owner" do
        before do
          sign_in user
          visit review_feedback_path(review, feedback)
        end

        it "displays feedback information" do
          page.should have_selector("h2", text: jc.user.name)
          page.should have_selector("h2", text: review.review_type)
          page.should have_content(user.name)
          inputs.values.each do |value|
            page.should have_content(value)
          end
        end

        it "links to edit page" do
          click_link "Edit"
          current_path.should == edit_review_feedback_path(review, feedback)
        end
      end

      describe "as an admin" do
        before do
          sign_in admin
          visit review_feedback_path(review, feedback)
        end

        it "redirects to homepage" do
          current_path.should == root_path
          page.should have_selector('div.alert.alert-alert', text:"You are not authorized to access this page.")
        end
      end
    end

    describe "submitted feedback" do
      before do
        feedback.update_attribute(:submitted, true)
      end

      describe "as the feedback owner" do
        before do
          sign_in user
          visit review_feedback_path(review, feedback)
        end

        it "displays feedback information with no 'Edit' link" do
          page.should have_selector("h2", text: jc.user.name)
          page.should have_selector("h2", text: review.review_type)
          page.should have_content(user.name)
          inputs.values.each do |value|
            page.should have_content(value)
          end

          page.should_not have_selector("a", text: "Edit")
        end
      end

      describe "as an admin" do
        before do
          sign_in admin
          visit review_feedback_path(review, feedback)
        end

        it "displays feedback information" do
          page.should have_selector("h2", text: jc.user.name)
          page.should have_selector("h2", text: review.review_type)
          page.should have_content(user.name)
          inputs.values.each do |value|
            page.should have_content(value)
          end
        end

        it "links to edit page" do
          click_link "Edit"
          current_path.should == edit_review_feedback_path(review, feedback)
        end
      end

      describe "as the junior consultant" do
        before do
          sign_in jc_user
          visit review_feedback_path(review, feedback)
        end

        it "displays feedback information with no 'Edit' link" do
          page.should have_selector("h2", text: jc.user.name)
          page.should have_selector("h2", text: review.review_type)
          page.should have_content(user.name)
          inputs.values.each do |value|
            page.should have_content(value)
          end

          page.should_not have_selector("a", text: "Edit")
        end
      end

      describe "as another user" do
        before do
          sign_in FactoryGirl.create(:user)
          visit review_feedback_path(review, feedback)
        end

        it "redirects to homepage" do
          current_path.should == root_path
          page.should have_selector('div.alert.alert-alert', text:"You are not authorized to access this page.")
        end
      end
    end
  end
end
