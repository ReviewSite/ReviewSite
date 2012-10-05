require 'spec_helper'

describe "feedbacks/show" do
  before(:each) do
    @review = FactoryGirl.create(:review)
    assign(:review_id, @review.id)
    @feedback = assign(:feedback, stub_model(Feedback,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Project Worked On/)
    rendered.should match(/Role Description/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/#{@review.id}/)
  end
end
