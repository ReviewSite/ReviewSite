require 'spec_helper'

describe "feedbacks/index" do
  before(:each) do
    @review = FactoryGirl.create(:review)
    @user = FactoryGirl.create(:user)
    assign(:feedbacks, [
           FactoryGirl.create(:feedback, :review => @review, :user => @user, :project_worked_on => "First Project Worked On"),
           FactoryGirl.create(:feedback, :review => @review, :user => @user, :project_worked_on => "Second Project Worked On")
    ])
  end

  it "renders a list of feedbacks" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => @user.name.to_s, :count => 2
    assert_select "tr>td", :text => "First Project Worked On".to_s, :count => 1
    assert_select "tr>td", :text => "Second Project Worked On".to_s, :count => 1
    assert_select "tr>td", :text => @review.junior_consultant.name.to_s, :count => 2
    assert_select "tr>td", :text => @review.review_type.to_s, :count => 2
  end
end
