require 'spec_helper'

describe ReviewingGroup do
  it "must specify a name" do
    rg = ReviewingGroup.new
    rg.valid?.should == false
    rg.name = "Chicago"
    rg.valid?.should == true
  end
end
