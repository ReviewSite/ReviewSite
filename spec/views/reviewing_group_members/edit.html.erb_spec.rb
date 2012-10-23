require 'spec_helper'

describe "reviewing_group_members/edit" do
  before(:each) do
    @reviewing_group_member = assign(:reviewing_group_member, stub_model(ReviewingGroupMember,
      :reviewing_group_id => 1,
      :user_id => 1
    ))
  end

  it "renders the edit reviewing_group_member form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => reviewing_group_members_path(@reviewing_group_member), :method => "post" do
      assert_select "input#reviewing_group_member_reviewing_group_id", :name => "reviewing_group_member[reviewing_group_id]"
      assert_select "input#reviewing_group_member_user_id", :name => "reviewing_group_member[user_id]"
    end
  end
end
