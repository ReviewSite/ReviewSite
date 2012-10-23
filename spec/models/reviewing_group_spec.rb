require 'spec_helper'

describe ReviewingGroup do
  it "must specify a name" do
    rg = ReviewingGroup.new
    rg.valid?.should == false
    rg.name = "Chicago"
    rg.valid?.should == true
  end

  it "has Reviewing Group Members" do
    rg = FactoryGirl.create(:reviewing_group)
    rgm = FactoryGirl.create(:reviewing_group_member, :reviewing_group => rg)
    rg.reviewing_group_members.should == [rgm]
  end

  it "has members function which summarizes groups" do
    rg = FactoryGirl.create(:reviewing_group)
    user = FactoryGirl.create(:user, :name => "Bob")
    user2 = FactoryGirl.create(:user, :name => "Jane")
    rgm = FactoryGirl.create(:reviewing_group_member, :reviewing_group => rg, :user => user)
    rgm = FactoryGirl.create(:reviewing_group_member, :reviewing_group => rg, :user => user2)
    rg.members.should == "Bob,Jane"
  end
end
