require 'spec_helper'

describe "reviewing_group_members/index" do
  before(:each) do
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user, :name => "bob")
    @rg1 = FactoryGirl.create(:reviewing_group, :name => "My Group")
    @rg2 = FactoryGirl.create(:reviewing_group, :name => "Your Group")
    assign(:reviewing_group_members, [
           FactoryGirl.create(:reviewing_group_member, :user => @user1, :reviewing_group => @rg1),
           FactoryGirl.create(:reviewing_group_member, :user => @user2, :reviewing_group => @rg2),
    ])
  end

  it "renders a list of reviewing_group_members" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => @user1.to_s, :count => 1
    assert_select "tr>td", :text => @user2.to_s, :count => 1
    assert_select "tr>td", :text => @rg1.to_s, :count => 1
    assert_select "tr>td", :text => @rg2.to_s, :count => 1
  end
end
