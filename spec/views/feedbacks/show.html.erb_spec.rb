require 'spec_helper'

describe "feedbacks/show" do
  before(:each) do
    @review = FactoryGirl.create(:review)
    assign(:review_id, @review.id)
    @user = FactoryGirl.create(:user)
    @feedback = FactoryGirl.create(:feedback, :review => @review, :user => @user, :project_worked_on => "Project Worked On", :role_description => "Role Description")

    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/#{@user.name}/)
    rendered.should match(/Project Worked On/)
    rendered.should match(/Role Description/)
  end
end
