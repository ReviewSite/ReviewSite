require 'spec_helper'

describe Review do
  describe "review" do
    before(:each) do
      @review = FactoryGirl.create(:review)
    end

    it "is valid" do
      @review.valid?.should be_true
    end

    it "must have a ac" do
      @review.associate_consultant = nil
      @review.valid?.should be_false
    end

    it "must have a review period" do
      @review.review_type = nil
      @review.valid?.should be_false
    end

    it "can find its consultant" do
      r = Review.new
      c = FactoryGirl.create(:associate_consultant)
      r.review_type = "6-Month"
      r.feedback_deadline = Date.today
      r.review_date = Date.today
      r.associate_consultant = c

      r.save.should be_true
    end

    it "allows different Review Types" do
      TYPES = ["6-Month", "12-Month", "18-Month", "24-Month"]
      TYPES.each do |type|
        @review.review_type = type
        @review.valid?.should be_true
      end
    end

    it "disallows Review Type of 2-Month" do
      @review.review_type = "2-Month"
      @review.valid?.should be_false
    end

    it "requires a feedback_deadline" do
      @review.feedback_deadline = nil
      @review.valid?.should be_false
    end

    it "requires a review_date" do
      @review.review_date = nil
      @review.valid?.should be_false
    end
  end

  it "has feedback" do
    r = FactoryGirl.create(:review)
    f = FactoryGirl.create(:feedback, :review => r)

    r.feedbacks.should == [f]
  end

  it "cannot have the same review_type for the same AC" do
    r1 = FactoryGirl.create(:review)
    r2 = FactoryGirl.build(:review, :review_type => r1.review_type, :associate_consultant => r1.associate_consultant)

    r2.valid?.should be_false
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

  it "can generate reviews" do
    arguments = Array.new
    desired_arguments = Array.new
    ac = double(AssociateConsultant,
      id: 1,
      program_start_date: Date.today - 2 )

    reviews = Review.create_default_reviews(ac)

    (0..3).each do |i|
      month = (i + 1) * 6
      review = reviews[i]
      review.associate_consultant_id.should == ac.id
      review.review_type.should == month.to_s + "-Month"
      review.review_date.should == ac.program_start_date + month.months
      review.feedback_deadline.should == ac.program_start_date + month.months - 7.days
    end
  end
end
