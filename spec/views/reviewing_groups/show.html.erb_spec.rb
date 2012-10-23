require 'spec_helper'

describe "reviewing_groups/show" do
  before(:each) do
    @reviewing_group = assign(:reviewing_group, stub_model(ReviewingGroup,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
