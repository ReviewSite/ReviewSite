require 'spec_helper'

describe "reviews/index" do
  before(:each) do
    assign(:reviews, [
      stub_model(Review,
        :junior_consultant_id => 1,
        :review_type => "Review Type"
      ),
      stub_model(Review,
        :junior_consultant_id => 1,
        :review_type => "Review Type"
      )
    ])
  end

  it "renders a list of reviews" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Review Type".to_s, :count => 2
  end
end
