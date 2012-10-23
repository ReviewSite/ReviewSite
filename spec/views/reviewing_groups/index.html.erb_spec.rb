require 'spec_helper'

describe "reviewing_groups/index" do
  before(:each) do
    assign(:reviewing_groups, [
      stub_model(ReviewingGroup,
        :name => "Name"
      ),
      stub_model(ReviewingGroup,
        :name => "Name"
      )
    ])
  end

  it "renders a list of reviewing_groups" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
