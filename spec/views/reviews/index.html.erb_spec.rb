require 'spec_helper'

describe "reviews/index" do
  before(:each) do
    @jc = FactoryGirl.create(:junior_consultant)
    assign(:reviews, [
           FactoryGirl.create(:review, :junior_consultant => @jc, :review_type => "6-Month"),
           FactoryGirl.create(:review, :junior_consultant => @jc, :review_type => "12-Month")
    ])
  end

  it "renders a list of reviews" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => @jc.to_s, :count => 2
    assert_select "tr>td", :text => "6-Month".to_s, :count => 1
    assert_select "tr>td", :text => "12-Month".to_s, :count => 1
  end
end
