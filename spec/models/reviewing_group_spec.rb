require 'spec_helper'

describe ReviewingGroup do
  it "must specify a name" do
    rg = ReviewingGroup.new
    rg.should_not be_valid
    rg.name = "Chicago"
    rg.should be_valid
  end

  it "has members who are Users" do
    user = FactoryGirl.create(:user)
    rg = FactoryGirl.create(:reviewing_group_with_users, :users => [user])
    # user = FactoryGirl.create(:user, :reviewing_group => rg)


    # user = FactoryGirl.create(:user, :companies => [company])

    rg.users.should eql [user]
  end

  it "has members function which summarizes groups" do
    rg = FactoryGirl.create(:reviewing_group)
    rg.users << FactoryGirl.create(:user, :name => "Bob")
    rg.users << FactoryGirl.create(:user, :name => "Jane")
    rg.members.should == "Bob, Jane"
  end
end
