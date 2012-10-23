require 'spec_helper'

describe ReviewingGroupMember do
  it "must have a reviewing_group" do
    rgm = ReviewingGroupMember.new
    rgm.user = FactoryGirl.create(:user)
    rgm.valid?.should == false
    rgm.reviewing_group = FactoryGirl.create(:reviewing_group)
    rgm.valid?.should == true
  end

  it "must have a user_id" do
    rgm = ReviewingGroupMember.new
    rgm.reviewing_group = FactoryGirl.create(:reviewing_group)
    rgm.valid?.should == false
    rgm.user = FactoryGirl.create(:user)
    rgm.valid?.should == true
  end
end
