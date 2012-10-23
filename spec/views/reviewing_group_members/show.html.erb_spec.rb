require 'spec_helper'

describe "reviewing_group_members/show" do
  before(:each) do
    @reviewing_group_member = assign(:reviewing_group_member, stub_model(ReviewingGroupMember,
      :reviewing_group_id => 1,
      :user_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end
