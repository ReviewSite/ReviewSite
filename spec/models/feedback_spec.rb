require 'spec_helper'

describe Feedback do
  it "has a review" do
    f = Feedback.new
    f.valid?.should == false

    f.review = FactoryGirl.create(:review)

    f.valid?.should == true
  end
end
