require 'spec_helper'

describe Review do
  describe "review" do
    before(:each) do
      @review = create(:review)
    end

    it "is valid" do
      @review.valid?.should be true
    end

    it "must have a ac" do
      @review.associate_consultant = nil
      @review.valid?.should be false
    end

    it "must have a review period" do
      @review.review_type = nil
      @review.valid?.should be false
    end

    it "allows different Review Types" do
      TYPES = ["6-Month", "12-Month", "18-Month", "24-Month"]
      TYPES.each do |type|
        @review.review_type = type
        @review.valid?.should be true
      end
    end

    it "disallows a review with a blank Review Type" do
      @review.review_type = nil
      @review.valid?.should be false
    end

    it "should remove extra error messages when the Review Type is blank" do
      @review.review_type = nil
      @review.valid?
      @review.errors[:review_type].count == 1
      @review.errors.messages[:review_type].should include("can't be blank.")
    end

    it "disallows Review Type of 2-Month" do
      @review.review_type = "2-Month"
      @review.valid?.should be false
    end

    it "requires a feedback_deadline" do
      @review.feedback_deadline = nil
      @review.valid?.should be false
    end

    it "requires a review_date" do
      @review.review_date = nil
      @review.valid?.should be false
    end
  end

  it "has feedback" do
    r = create(:review)
    f = create(:feedback, :review => r)

    r.feedbacks.should == [f]
  end

  it "cannot have the same review_type for the same AC" do
    r1 = create(:review)
    r2 = build(:review, :review_type => r1.review_type, :associate_consultant => r1.associate_consultant)

    r2.valid?.should be false
  end

  describe "review with multiple feedbacks" do
    before(:each) do
      @review = create(:review)
      @fb1 = create(:feedback, :review => @review)
      @fb2 = create(:feedback, :review => @review)
    end

    it "should delete related feedback" do
      Feedback.all.count.should == 2
      @review.destroy
      Feedback.all.count.should == 0
    end
  end

  it "has self_assessments" do
    r = create(:review)
    s = create(:self_assessment, :review => r)
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

  describe "#in_the_future?" do
    it "returns true when review date is in the future from today" do
      review = Review.new
      review.review_date = 2.days.from_now
      review.in_the_future?.should be true
    end
    it "returns false when review date is not in the future from today" do
      review = Review.new
      review.review_date = 2.days.ago
      review.in_the_future?.should be false
    end
    it "returns false when review date is not set" do
      review = Review.new
      review.review_date = nil
      review.in_the_future?.should be false
    end
  end

  describe "#feedback_deadline_is_before_review_date?" do
    it "returns true when feedback deadline is before or on review date" do
      review = build(:review, review_date: 1.day.from_now, feedback_deadline: 1.day.ago)
      review.valid?.should be true
    end
    it "returns false when feedback deadline is after review date" do
      review = build(:review, review_date: 1.day.from_now, feedback_deadline: 2.days.from_now)
      review.valid?.should be false
    end
    it "returns false when feedback deadline is same day as review" do
      date = 1.day.from_now
      review = build(:review, review_date: date, feedback_deadline: date)
      review.valid?.should be false
    end
  end

  describe "#upcoming?" do
    it "returns false if review date is blank" do
      review = create(:review)
      review.review_date = nil
      review.upcoming?.should be false
    end

    it "returns false if review date is not in next six months" do
      review = create(:review, review_date: 12.months.from_now)
      review.upcoming?.should be false
    end

    describe  "when ac has only one review in the next six months" do
      it "returns true if review date is in next six months" do
        review = create(:review, review_date: 6.months.from_now - 1.day)
        review.upcoming?.should be true
      end
    end

    describe "when ac has more than one review in the next six months" do
      it "returns true if it is the first review date in next six months" do
        ac = create(:associate_consultant)
        review1 = create(:review, review_type: "6-Month", review_date: 3.days.from_now, associate_consultant: ac)
        review2 = create(:review, review_type: "12-Month", review_date: 6.months.from_now - 2.days, associate_consultant: ac)

        review1.upcoming?.should be true
      end

      it "returns false if it is not the first review date in next six months" do
        ac = create(:associate_consultant)
        review1 = create(:review, review_type: "6-Month", review_date: 3.days.from_now, associate_consultant: ac)
        review2 = create(:review, review_type: "12-Month", review_date: 6.months.from_now - 2.days, associate_consultant: ac)

        review2.upcoming?.should be false
      end
    end
  end
end
