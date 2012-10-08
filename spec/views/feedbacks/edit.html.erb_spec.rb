require 'spec_helper'

describe "feedbacks/edit" do
  before(:each) do
    @review = FactoryGirl.create(:review)
    @user = FactoryGirl.create(:user)
    @user_name = @user.name
    @feedback = assign(:feedback, stub_model(Feedback,
      :user_id => @user.id,
      :project_worked_on => "MyString",
      :role_description => "MyString",
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
    ))
  end

  it "renders the edit feedback form" do
    render


    rendered.should match(/#{@review.junior_consultant}/)

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => review_feedbacks_path(@review, @feedback), :method => "post" do
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
    end
  end
end
