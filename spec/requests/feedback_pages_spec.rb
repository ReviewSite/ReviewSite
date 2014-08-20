require 'spec_helper'

describe "Feedback pages", :type => :feature do
  let(:ac_user) { FactoryGirl.create(:user) }
  let(:ac) { FactoryGirl.create(:associate_consultant, :user => ac_user) }
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin_user) }
  let(:review) { FactoryGirl.create(:review, associate_consultant: ac) }


  subject { page }

  describe "new", :type => :feature do
    let(:new_feedback_page) { NewFeedbackPO.new }

    before do
      sign_in user
      new_feedback_page.load(review_id: review.id)
    end

    describe "if no existing feedback", js: true, :type => :feature do
      before do
        visit new_review_feedback_path(review)

        new_feedback_page.inputs.each do |header, fields|
          header.click
          fields.each do |field|
            fill_in field[0], with: field[1]
          end
        end
      end

      it "saves as draft if 'Save Feedback' button is clicked" do
        new_feedback_page.save_feedback_button.click
        feedback = Feedback.last
        current_path.should == edit_review_feedback_path(review, feedback)
        feedback.submitted.should be_false
        new_feedback_page.inputs.each do |section, inputs|
          inputs.each do |input|
            model_attr = input[0][9..-1]
            value = input[1]
            feedback.send(model_attr).should == value
          end
        end
      end

      it "saves as final and sends email if 'Submit Final' is clicked", js: true do
        new_feedback_page.submit_final_button.click
        page.evaluate_script('window.confirm = function() { return true; }')
        feedback = Feedback.last
        current_path.should == review_feedback_path(review, feedback)
        feedback.submitted.should be_true
        feedback_show_page = FeedbackShowPO.new
        feedback_show_page.load(review_id: review.id, feedback_id: feedback.id)
        feedback_show_page.review_values.each do |element|
        end
      end

    end

  end

  # describe "edit" do
  #   let(:feedback) { FactoryGirl.create(:feedback, review: review, user: user) }
  #   let(:edit_feedback_page) { EditFeedbackPO.new }

  #   describe "as feedback owner" do
  #     before do
  #       sign_in user
  #       edit_feedback_page.load(review_id: review.id, feedback_id: feedback.id)
  #     end

  #     describe "if feedback has been saved as draft" do
  #       before do
  #         edit_feedback_page.inputs.each do |field, value|
  #           model_attr = field[9..-1]
  #           feedback.update_attribute(model_attr, value)
  #         end
  #         visit edit_review_feedback_path(review, feedback)
  #       end

  #       it "reloads saved feedback" do
  #         edit_feedback_page.inputs.each do |field, value|
  #           if ['feedback_project_worked_on', 'feedback_role_description'].include?(field)
  #             edit_feedback_page.should have_field(field, with: value)
  #           else
  #             edit_feedback_page.should have_selector("##{field}", text: value)
  #           end
  #         end
  #       end

  #       it "saves as draft if 'Save Feedback' is clicked" do
  #         edit_feedback_page.inputs.each do |field, value|
  #           fill_in field, with: ""
  #         end

  #         edit_feedback_page.save_buttons.last.click
  #         feedback = Feedback.last
  #         current_path.should == edit_review_feedback_path(review, feedback)
  #         feedback.submitted.should be_false

  #         edit_feedback_page.inputs.each do |field, value|
  #           model_attr = field[9..-1]
  #           feedback.send(model_attr).should == ""
  #         end
  #       end

  #     end

  #     describe "if feedback has been submitted" do
  #       before do
  #         feedback.update_attribute(:submitted, true)
  #         visit edit_review_feedback_path(review, feedback)
  #       end

  #       it "should redirect to homepage" do
  #         current_path.should == root_path
  #         edit_feedback_page.should have_selector('div.alert.alert-alert', text:"You are not authorized to access this page.")
  #       end
  #     end
  #   end

  #   describe "as other user" do
  #     before do
  #       sign_in FactoryGirl.create(:user)
  #       visit edit_review_feedback_path(review, feedback)
  #     end

  #     it "should redirect to homepage" do
  #       current_path.should == root_path
  #       edit_feedback_page.should have_selector('div.alert.alert-alert', text:"You are not authorized to access this page.")
  #     end
  #   end
  # end

  # describe "additional" do
  #   before do
  #     sign_in FactoryGirl.create(:user)
  #     visit additional_review_feedbacks_path(review)
  #     fill_in "feedback_user_string", with: "A non-user"

  #     page.find('h3', :text => 'Comments').click

  #     new_feedback_page.inputs.each do |field, value|
  #       fill_in field, with: value
  #     end
  #   end

  #   it "saves as draft if 'Save Feedback' is clicked" do
  #     #click_button "Save Feedback"
  #     new_feedback_page.save_buttons.last.click
  #     feedback = Feedback.last
  #     current_path.should == edit_review_feedback_path(review, feedback)
  #     feedback.submitted.should be_false
  #     feedback.user_string.should == "A non-user"
  #     new_feedback_page.inputs.each do |field, value|
  #       model_attr = field[9..-1]
  #       feedback.send(model_attr).should == value
  #     end
  #   end
  # end

  # describe "show" do
  #   let(:feedback) { FactoryGirl.create(:feedback, review: review, user: user) }

  #   before do
  #     new_feedback_page.inputs.each do |field, value|
  #       model_attr = field[9..-1]
  #       feedback.update_attribute(model_attr, value)
  #     end
  #   end

  #   describe "unsubmitted feedback" do
  #     describe "as feedback owner" do
  #       before do
  #         sign_in user
  #         visit review_feedback_path(review, feedback)
  #       end

  #       it "displays feedback information" do
  #         page.should have_selector("h2", text: ac.user.name)
  #         page.should have_selector("h2", text: review.review_type)
  #         page.should have_content(user.name)
  #         new_feedback_page.inputs.values.each do |value|
  #           page.should have_content(value)
  #         end
  #       end

  #       it "links to edit page" do
  #         click_link "Edit"
  #         current_path.should == edit_review_feedback_path(review, feedback)
  #       end
  #     end

  #     describe "as an admin" do
  #       before do
  #         sign_in admin
  #         visit review_feedback_path(review, feedback)
  #       end

  #       it "redirects to homepage" do
  #         current_path.should == root_path
  #         page.should have_selector('div.alert.alert-alert', text:"You are not authorized to access this page.")
  #       end
  #     end
  #   end

  #   describe "submitted feedback" do
  #     before do
  #       feedback.update_attribute(:submitted, true)
  #     end

  #     describe "as the feedback owner" do
  #       before do
  #         sign_in user
  #         visit review_feedback_path(review, feedback)
  #       end

  #       it "displays feedback information with no 'Edit' link" do
  #         page.should have_selector("h2", text: ac.user.name)
  #         page.should have_selector("h2", text: review.review_type)
  #         page.should have_content(user.name)
  #         new_feedback_page.inputs.values.each do |value|
  #           page.should have_content(value)
  #         end

  #         page.should_not have_selector("a", text: "Edit")
  #       end
  #     end

  #     describe "as an admin" do
  #       before do
  #         sign_in admin
  #         visit review_feedback_path(review, feedback)
  #       end

  #       it "displays feedback information" do
  #         page.should have_selector("h2", text: ac.user.name)
  #         page.should have_selector("h2", text: review.review_type)
  #         page.should have_content(user.name)
  #         new_feedback_page.inputs.values.each do |value|
  #           page.should have_content(value)
  #         end
  #       end

  #       it "links to edit page" do
  #         click_link "Edit"
  #         current_path.should == edit_review_feedback_path(review, feedback)
  #       end
  #     end

  #     describe "as the associate consultant" do
  #       before do
  #         sign_in ac_user
  #         visit review_feedback_path(review, feedback)
  #       end

  #       it "displays feedback information with no 'Edit' link" do
  #         page.should have_selector("h2", text: ac.user.name)
  #         page.should have_selector("h2", text: review.review_type)
  #         page.should have_content(user.name)
  #         new_feedback_page.inputs.values.each do |value|
  #           page.should have_content(value)
  #         end

  #         page.should_not have_selector("a", text: "Edit")
  #       end
  #     end

  #     describe "as another user" do
  #       before do
  #         sign_in FactoryGirl.create(:user)
  #         visit review_feedback_path(review, feedback)
  #       end

  #       it "redirects to homepage" do
  #         current_path.should == root_path
  #         page.should have_selector('div.alert.alert-alert', text:"You are not authorized to access this page.")
  #       end
  #     end
  #   end
  # end

end
