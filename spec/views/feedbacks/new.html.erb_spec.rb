require 'spec_helper'

describe "feedbacks/new" do
  describe "old_format review" do
    before(:each) do
      @review = FactoryGirl.create(:review, :new_review_format => false)
      @user = FactoryGirl.create(:user)
      @feedback = FactoryGirl.build(:feedback, :user => @user, :review => @review)
      @user_name = @user.name
    end

    it "renders new feedback form" do
      render

      rendered.should match(/#{@review.junior_consultant}/)
        rendered.should match(/#{@review.review_type}/)

        # Run the generator again with the --webrat flag if you want to use webrat matchers
        assert_select "form", :action => review_feedbacks_path(@review), :method => "post" do
          assert_select "input#feedback_project_worked_on", :name => "feedback[project_worked_on]"
          assert_select "input#feedback_role_description", :name => "feedback[role_description]"

          assert_select "textarea#feedback_tech_exceeded", :name => "feedback[tech_exceeded]"
          assert_select "textarea#feedback_tech_met", :name => "feedback[tech_met]"
          assert_select "textarea#feedback_tech_improve", :name => "feedback[tech_improve]"
          assert_select "textarea#feedback_client_exceeded", :name => "feedback[client_exceeded]"
          assert_select "textarea#feedback_client_met", :name => "feedback[client_met]"
          assert_select "textarea#feedback_client_improve", :name => "feedback[client_improve]"
          assert_select "textarea#feedback_ownership_exceeded", :name => "feedback[ownership_exceeded]"
          assert_select "textarea#feedback_ownership_met", :name => "feedback[ownership_met]"
          assert_select "textarea#feedback_ownership_improve", :name => "feedback[ownership_improve]"
          assert_select "textarea#feedback_leadership_exceeded", :name => "feedback[leadership_exceeded]"
          assert_select "textarea#feedback_leadership_met", :name => "feedback[leadership_met]"
          assert_select "textarea#feedback_leadership_improve", :name => "feedback[leadership_improve]"
          assert_select "textarea#feedback_teamwork_exceeded", :name => "feedback[teamwork_exceeded]"
          assert_select "textarea#feedback_teamwork_met", :name => "feedback[teamwork_met]"
          assert_select "textarea#feedback_teamwork_improve", :name => "feedback[teamwork_improve]"
          assert_select "textarea#feedback_attitude_exceeded", :name => "feedback[attitude_exceeded]"
          assert_select "textarea#feedback_attitude_met", :name => "feedback[attitude_met]"
          assert_select "textarea#feedback_attitude_improve", :name => "feedback[attitude_improve]"
          assert_select "textarea#feedback_professionalism_exceeded", :name => "feedback[professionalism_exceeded]"
          assert_select "textarea#feedback_professionalism_met", :name => "feedback[professionalism_met]"
          assert_select "textarea#feedback_professionalism_improve", :name => "feedback[professionalism_improve]"
          assert_select "textarea#feedback_organizational_exceeded", :name => "feedback[organizational_exceeded]"
          assert_select "textarea#feedback_organizational_met", :name => "feedback[organizational_met]"
          assert_select "textarea#feedback_organizational_improve", :name => "feedback[organizational_improve]"
          assert_select "textarea#feedback_innovative_exceeded", :name => "feedback[innovative_exceeded]"
          assert_select "textarea#feedback_innovative_met", :name => "feedback[innovative_met]"
          assert_select "textarea#feedback_innovative_improve", :name => "feedback[innovative_improve]"

          assert_select "textarea#feedback_comments", :name => "feedback[comments]"
          assert_select "input", :name => "commit"
        end
    end
  end

  describe "new_format review" do
    before(:each) do
      @review = FactoryGirl.create(:review, :new_review_format => true)
      @user = FactoryGirl.create(:user)
      @feedback = FactoryGirl.build(:feedback, :user => @user, :review => @review)
      @user_name = @user.name
    end

    it "renders new feedback form" do
      render

      rendered.should match(/#{@review.junior_consultant}/)
        rendered.should match(/#{@review.review_type}/)

        # Run the generator again with the --webrat flag if you want to use webrat matchers
        assert_select "form", :action => review_feedbacks_path(@review), :method => "post" do
          assert_select "input#feedback_project_worked_on", :name => "feedback[project_worked_on]"

          assert_select "textarea#feedback_role_competence_went_well", :name => "feedback[role_competence_went_well]"
          assert_select "textarea#feedback_role_competence_to_be_improved", :name => "feedback[role_competence_to_be_improved]"
          assert_select "textarea#feedback_role_competence_action_items", :name => "feedback[role_competence_action_items]"
          assert_select "textarea#feedback_consulting_skills_went_well", :name => "feedback[consulting_skills_went_well]"
          assert_select "textarea#feedback_consulting_skills_to_be_improved", :name => "feedback[consulting_skills_to_be_improved]"
          assert_select "textarea#feedback_consulting_skills_action_items", :name => "feedback[consulting_skills_action_items]"
          assert_select "textarea#feedback_teamwork_went_well", :name => "feedback[teamwork_went_well]"
          assert_select "textarea#feedback_teamwork_to_be_improved", :name => "feedback[teamwork_to_be_improved]"
          assert_select "textarea#feedback_teamwork_action_items", :name => "feedback[teamwork_action_items]"
          assert_select "textarea#feedback_contributions_went_well", :name => "feedback[contributions_went_well]"
          assert_select "textarea#feedback_contributions_to_be_improved", :name => "feedback[contributions_to_be_improved]"
          assert_select "textarea#feedback_contributions_action_items", :name => "feedback[contributions_action_items]"

          assert_select "textarea#feedback_comments", :name => "feedback[comments]"
          assert_select "input", :name => "commit"
        end
    end
  end
end
