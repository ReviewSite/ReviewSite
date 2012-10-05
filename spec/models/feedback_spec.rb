require 'spec_helper'

describe Feedback do
  it "has a review" do
    f = Feedback.new
    f.user = FactoryGirl.create(:user)
    f.valid?.should == false

    f.review = FactoryGirl.create(:review)

    f.valid?.should == true
  end

  it "has a user" do
    f = Feedback.new
    f.review = FactoryGirl.create(:review)
    f.valid?.should == false

    f.user = FactoryGirl.create(:user)

    f.valid?.should == true
  end
end
