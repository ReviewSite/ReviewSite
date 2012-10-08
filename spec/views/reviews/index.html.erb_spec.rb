require 'spec_helper'

describe "reviews/index" do
  before(:each) do
    @jc = FactoryGirl.create(:junior_consultant)
    @review1 = FactoryGirl.create(:review, :junior_consultant => @jc, :review_type => "6-Month")
    @review2 = FactoryGirl.create(:review, :junior_consultant => @jc, :review_type => "12-Month")
    assign(:reviews, [
           @review1, @review2
    ])
    @feedback1 = FactoryGirl.create(:feedback, :review => @review1)

    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }
  end

  it "renders a list of reviews" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => @jc.to_s, :count => 2
    assert_select "tr>td", :text => "6-Month".to_s, :count => 1
    assert_select "tr>td", :text => "12-Month".to_s, :count => 1
    assert_select "tr>td", :text => 1.to_s, :count => 1 # @review1 has 1 feedback
    assert_select "tr>td", :text => 0.to_s, :count => 1 # @review2 has 0 feedback
  end
end
