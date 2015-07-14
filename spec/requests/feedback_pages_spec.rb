require 'spec_helper'

describe "Feedback pages", :type => :feature do
  let(:ac_user) { create(:user) }
  let(:ac) { create(:associate_consultant, :user => ac_user) }
  let(:user) { create(:user) }
  let(:admin) { create(:admin_user) }
  let!(:review) { create(:review, associate_consultant: ac) }
  let(:inputs) { {
    'feedback_comments' => 'My Comments'
  } }

  subject { page }

  describe "'Create New Feedback' page" do
    before do
      @current_ac = create(:associate_consultant)
      @current_review = create(:review, :associate_consultant => @current_ac)
      @new_user = create(:user)
      @invitation = create(:invitation, :email => @new_user.email, :review => @current_review)
    end

    context "when no previous feedback exists", js: true do
      before do
        sign_in @new_user
        visit new_review_feedback_path(@current_review)

        inputs.each do |field, value|
          fill_in field, with: value
        end
      end

      it "saves as draft when 'Save Feedback' is clicked" do
        page.execute_script(' $("#save-feedback-button").click(); ')
        page.should have_selector(".flash")
        feedback = Feedback.last
        feedback.submitted.should be_false

        inputs.each do |field, value|
          model_attr = field[9..-1]
          feedback.send(model_attr).should == value
        end
      end

      it "redirects to the preview page when 'Preview & Submit' is clicked" do
        click_button("Preview & Submit")
        feedback = Feedback.last
        current_path.should == preview_review_feedback_path(@current_review, feedback)
      end
    end
  end

  describe "'Preview and Submit Feedback' page" do
    let!(:user) { create(:user) }
    let(:feedback_user) { create(:user) }
    let(:ac) { create(:associate_consultant, user: user) }
    let!(:review) { create(:review, associate_consultant: ac) }
    let(:feedback) { create(:feedback, review: review,
      user: user) }

    before do
      sign_in user
      visit preview_review_feedback_path(review, feedback)
    end

    it "saves as final and sends email when 'Submit Final' is clicked", js: true do
      ActionMailer::Base.deliveries.clear
      page.evaluate_script('window.confirm = function() { return true; }')
      click_button("Submit")
      page.should have_selector(".flash")

      id = feedback.id
      feedback = Feedback.find(id)
      current_path.should == completed_feedback_user_path(user)
      feedback.submitted.should be_true

      ActionMailer::Base.deliveries.length.should == 2
      mail = ActionMailer::Base.deliveries.first
      mail.to.should == [ac.user.email]
      mail.subject.should == "[ReviewSite] You have new feedback from #{feedback.user}"
    end


    it "redirects to 'Edit' page when 'Edit' is clicked" do
      click_button("Edit")
      current_path.should == edit_review_feedback_path(review, feedback)
    end
  end

  describe "'Edit Feedback' page" do
    let!(:invitation) { create(:invitation, email: user.email, review: review) }
    let(:feedback) { create(:feedback, review: review, user: user) }

    describe "as feedback owner" do
      before { sign_in user }

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

          page.find("#save-feedback-button").click
          feedback = Feedback.last
          current_path.should == edit_review_feedback_path(review, feedback)
          feedback.submitted.should be_false

          inputs.each do |field, value|
            model_attr = field[9..-1]
            feedback.send(model_attr).should == ""
          end
        end

        it "redirects to preview page when 'Preview & Submit' is click" do
          click_button("Preview & Submit")
          feedback_id = feedback.id
          current_path.should == preview_review_feedback_path(review, feedback)
        end
      end

      describe "if feedback has been submitted" do
        before do
          feedback.update_attribute(:submitted, true)
          visit edit_review_feedback_path(review, feedback)
        end

        it "should redirect to homepage" do
          current_path.should == root_path
          page.should have_selector('.flash-alert', text:"You are not authorized to access this page.")
        end
      end
    end

    describe "as other user" do
      before do
        sign_in create(:user)
        visit edit_review_feedback_path(review, feedback)
      end

      it "should redirect to homepage" do
        current_path.should == root_path
        page.should have_selector('.flash-alert', text:"You are not authorized to access this page.")
      end
    end
  end

  describe "'Give External Feedback' page" do
    before do
      sign_in ac_user
      visit additional_review_feedback_path(review)
      fill_in "feedback_project_worked_on", with: "A project"
      fill_in "feedback_role_description", with: "A role"
      fill_in "feedback_comments", with: "My Comments"
    end

    it "saves as draft if 'Save Feedback' is clicked" do
      page.find("#save-feedback-button").click
      feedback = Feedback.last
      current_path.should == edit_additional_review_feedback_path(review, feedback)
      feedback.submitted.should be_false
      feedback.project_worked_on == "A project"
      feedback.role_description == "A role"
      feedback.comments == "My Comments"
    end

    it "redirects to 'Preview & Submit' page when 'Preview & Submit' is clicked" do
      click_button("Preview & Submit")
      feedback = Feedback.last
      current_path.should == preview_review_feedback_path(review, feedback)
    end
  end

  describe "'Show Completed Feedback' page" do
    let(:feedback) { create(:feedback, review: review, user: user) }

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
          page.should have_selector("h2", text: ac.user.name)
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
          page.should have_selector('.flash-alert', text:"You are not authorized to access this page.")
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
          page.should have_selector("h2", text: ac.user.name)
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
          page.should have_selector("h2", text: ac.user.name)
          page.should have_selector("h2", text: review.review_type)
          page.should have_content(user.name)
          inputs.values.each do |value|
            page.should have_content(value)
          end
        end
      end

      describe "as the associate consultant" do
        before do
          sign_in ac_user
          visit review_feedback_path(review, feedback)
        end

        it "displays feedback information with no 'Edit' link" do
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
          sign_in create(:user)
          visit review_feedback_path(review, feedback)
        end

        it "redirects to homepage" do
          current_path.should == root_path
          page.should have_selector('.flash-alert', text: "You are not authorized to access this page.")
        end
      end
    end
  end

end
