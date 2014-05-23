require 'spec_helper'

describe Review do
  describe "with a FactoryGirl review" do
    before(:each) do
      @review = FactoryGirl.create(:review)
    end

    it "is valid" do
      @review.valid?.should == true
    end

    it "must have a jc" do
      @review.junior_consultant = nil
      @review.valid?.should == false
    end

    it "must have a review period" do
      @review.review_type = nil
      @review.valid?.should == false
    end

    it "can find its consultant" do
      r = Review.new
      c = FactoryGirl.create(:junior_consultant)
      r.review_type = "6-Month"
      r.feedback_deadline = Date.today

      r.junior_consultant = c

      r.save.should == true
    end

    it "allows different Review Types" do
      TYPES = ["6-Month", "12-Month", "18-Month", "24-Month"]
      TYPES.each do |type|
        @review.review_type = type
        @review.valid?.should == true
      end
    end
    it "disallows Review Type of 2-Month" do
      @review.review_type = "2-Month"
      @review.valid?.should == false
    end

    # it "requires a feedback_deadline" do
      # @review.feedback_deadline = nil
      # @review.valid?.should == false
    # end
  end

    it "has feedback" do
      r = FactoryGirl.create(:review)
      f = FactoryGirl.create(:feedback, :review => r)

      r.feedbacks.should == [f]
    end

    it "cannot have the same review_type for the same JC" do
      r1 = FactoryGirl.create(:review)
      r2 = FactoryGirl.build(:review, :review_type => r1.review_type, :junior_consultant => r1.junior_consultant)

      r2.valid?.should == false
    end
    describe "review with multiple feedbacks" do
      before(:each) do
        @review = FactoryGirl.create(:review)
        @fb1 = FactoryGirl.create(:feedback, :review => @review)
        @fb2 = FactoryGirl.create(:feedback, :review => @review)
      end

      it "should delete related feedback" do
        Feedback.all.count.should == 2
        @review.destroy
        Feedback.all.count.should == 0
      end
    end
    it "has self_assessments" do
      r = FactoryGirl.create(:review)
      s = FactoryGirl.create(:self_assessment, :review => r)
      r.self_assessments.should == [s]
    end
end
