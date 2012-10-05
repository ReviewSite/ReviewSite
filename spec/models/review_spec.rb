require 'spec_helper'

describe Review do
    it "has a consultant" do
        r = Review.new
        r.review_type = "6-Month"
        r.valid?.should == false

        r.junior_consultant_id = 1

        r.valid?.should == true
    end

    it "has a review period" do
        r = Review.new
        r.junior_consultant_id = 1
        r.valid?.should == false

        r.review_type = "6-Month"

        r.valid?.should == true
    end
end
