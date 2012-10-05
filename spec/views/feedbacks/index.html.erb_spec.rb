require 'spec_helper'

describe "feedbacks/index" do
  before(:each) do
    @review = FactoryGirl.create(:review)
    assign(:feedbacks, [
      stub_model(Feedback,
        :user_id => 1,
        :project_worked_on => "Project Worked On",
        :role_description => "Role Description",
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
      ),
      stub_model(Feedback,
        :user_id => 1,
        :project_worked_on => "Project Worked On",
        :role_description => "Role Description",
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
      )
    ])
  end

  it "renders a list of feedbacks" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Project Worked On".to_s, :count => 2
    assert_select "tr>td", :text => "Role Description".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 56
    assert_select "tr>td", :text => @review.id.to_s, :count => 2
  end
end
