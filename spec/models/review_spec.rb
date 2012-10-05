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

    it "can find its consultant" do
        r = Review.new
        c = JuniorConsultant.new
        c.name = "Robin"
        c.email = "rdunlop@thoughtworks.com"
        c.save!
        r.review_type = "6-Month"

        r.junior_consultant = c

        r.save.should == true
    end

    it "allows Review Type of 6-Month" do
        r = Review.new
        r.junior_consultant_id = 1

        r.review_type = "6-Month"

        r.valid?.should == true
    end
    it "allows Review Type of 12-Month" do
        r = Review.new
        r.junior_consultant_id = 1

        r.review_type = "12-Month"

        r.valid?.should == true
    end
    it "disallows Review Type of 2-Month" do
        r = Review.new
        r.junior_consultant_id = 1

        r.review_type = "2-Month"

        r.valid?.should == false
    end
end
