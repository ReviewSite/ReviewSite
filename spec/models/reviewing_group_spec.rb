require 'spec_helper'

describe ReviewingGroup do
  it "must specify a name" do
    rg = ReviewingGroup.new
    rg.should_not be_valid
    rg.name = "Chicago"
    rg.should be_valid
  end

  it "has members who are Users" do
    user = create(:user)
    rg = create(:reviewing_group_with_users, :users => [user])
    # user = create(:user, :reviewing_group => rg)
    rg.users.should eql [user]
  end

end
