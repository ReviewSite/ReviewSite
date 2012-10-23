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
end
