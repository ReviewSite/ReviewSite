require 'spec_helper'

describe "feedbacks/new" do
  before(:each) do
    @review = FactoryGirl.create(:review)
    @user = FactoryGirl.create(:user)
    assign(:feedback, stub_model(Feedback,
      :user_id => @user.id,
      :project_worked_on => "MyString",
      :role_description => "MyString",
      :role_competence_exceeded => "MyText", 
      :role_competence_improve => "MyText", 
      :role_competence_met => "MyText",
      :consulting_skills_exceeded => "MyText", 
      :consulting_skills_improve => "MyText", 
      :consulting_skills_met => "MyText", 
      :teamwork_exceeded => "MyText",
      :teamwork_met => "MyText",
      :teamwork_improve => "MyText",
      :contritubions_exceeded => "MyText", 
      :contritubions_improve => "MyText", 
      :contritubions_met => "MyText", 
      :tech_exceeded => "MyText",
      :tech_met => "MyText",
      :tech_improve => "MyText",
      :client_exceeded => "MyText",
      :client_met => "MyText",
      :client_improve => "MyText",
      :ownership_exceeded => "MyText",
      :ownership_met => "MyText",
      :ownership_improve => "MyText",
      :leadership_exceeded => "MyText",
      :leadership_met => "MyText",
      :leadership_improve => "MyText",
      :teamwork_exceeded => "MyText",
      :teamwork_met => "MyText",
      :teamwork_improve => "MyText",
      :attitude_exceeded => "MyText",
      :attitude_met => "MyText",
      :attitude_improve => "MyText",
      :professionalism_exceeded => "MyText",
      :professionalism_met => "MyText",
      :professionalism_improve => "MyText",
      :organizational_exceeded => "MyText",
      :organizational_met => "MyText",
      :organizational_improve => "MyText",
      :innovative_exceeded => "MyText",
      :innovative_met => "MyText",
      :innovative_improve => "MyText",
      :comments => "MyText",
      :review_id => @review.id
    ).as_new_record)
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
      # assert_select "textarea#feedback_role_competence_exceeded", :name => "feedback[role_competence_exceeded]"
      # assert_select "textarea#feedback_role_competence_met", :name => "feedback[role_competence_met]"
      # assert_select "textarea#feedback_role_competence_improve", :name => "feedback[role_competence_improve]"
      # assert_select "textarea#feedback_consulting_skills_exceeded", :name => "feedback[consulting_skills_exceeded]"
      # assert_select "textarea#feedback_consulting_skills_met", :name => "feedback[consulting_skills_met]"
      # assert_select "textarea#feedback_consulting_skills_improve", :name => "feedback[consulting_skills_improve]"
      assert_select "textarea#feedback_teamwork_exceeded", :name => "feedback[teamwork_exceeded]"
      assert_select "textarea#feedback_teamwork_met", :name => "feedback[teamwork_met]"
      assert_select "textarea#feedback_teamwork_improve", :name => "feedback[teamwork_improve]"
      # assert_select "textarea#feedback_contritubions_exceeded", :name => "feedback[contritubions_exceeded]"
      # assert_select "textarea#feedback_contritubions_met", :name => "feedback[contritubions_met]"
      # assert_select "textarea#feedback_contritubions_improve", :name => "feedback[contritubions_improve]"
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
