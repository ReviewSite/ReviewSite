require 'spec_helper'

describe "feedbacks/index" do
  before(:each) do
    @review = FactoryGirl.create(:review)
    @review2 = FactoryGirl.create(:review, :review_type => "12-Month")
    @user = FactoryGirl.create(:user)
    assign(:feedbacks, [
           FactoryGirl.create(:feedback, :review => @review, :user => @user, :project_worked_on => "First Project Worked On", :submitted => true),
           FactoryGirl.create(:feedback, :review => @review2, :user => @user, :project_worked_on => "Second Project Worked On", :submitted => false)
    ])
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }
  end

  it "renders a list of feedbacks" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => @user.name.to_s, :count => 2
    assert_select "tr>td", :text => "First Project Worked On".to_s, :count => 1
    assert_select "tr>td", :text => "Second Project Worked On".to_s, :count => 1
    assert_select "tr>td", :text => @review.junior_consultant.name.to_s, :count => 1
    assert_select "tr>td", :text => @review2.junior_consultant.name.to_s, :count => 1
    assert_select "tr>td", :text => @review.review_type.to_s, :count => 1
    assert_select "tr>td", :text => @review2.review_type.to_s, :count => 1
    assert_select "tr>td", :text => "Submitted", :count => 1
    assert_select "tr>td", :text => "Not-Submitted", :count => 1
  end
end
