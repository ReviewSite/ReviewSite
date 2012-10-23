require 'spec_helper'

describe "reviewing_group_members/new" do
  before(:each) do
    assign(:reviewing_group_member, stub_model(ReviewingGroupMember,
      :reviewing_group_id => 1,
      :user_id => 1
    ).as_new_record)
  end

  it "renders new reviewing_group_member form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => reviewing_group_members_path, :method => "post" do
      assert_select "input#reviewing_group_member_reviewing_group_id", :name => "reviewing_group_member[reviewing_group_id]"
      assert_select "input#reviewing_group_member_user_id", :name => "reviewing_group_member[user_id]"
    end
  end
end
