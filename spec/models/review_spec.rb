require 'spec_helper'

describe Review do
  describe "sort" do

    it "considers the first record greater if they both have nil review dates" do
      review_b = FactoryGirl.create(:review, review_date: nil)
      review_a = FactoryGirl.create(:review, review_date: nil)
      reviews  = [review_b, review_a]
      reviews.sort.should eq([review_a, review_b])
    end

    it "considers the second record greater if just it has a nil review date" do
      review_a = FactoryGirl.create(:review)
      review_b = FactoryGirl.create(:review, review_date: nil)
      reviews  = [review_a, review_b]
      reviews.sort.should eq([review_b, review_a])
    end

    it "sorts based on review date" do
      review_a = FactoryGirl.create(:review, review_date: 4.days.from_now)
      review_b = FactoryGirl.create(:review, review_date: 3.days.from_now)
      reviews  = [review_b, review_a]
      reviews.sort.should eq([review_b, review_a])
    end

  end
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
    it "allows Review Type of 18-Month" do
        r = Review.new
        r.junior_consultant_id = 1

        r.review_type = "18-Month"

        r.valid?.should == true
    end
    it "allows Review Type of 24-Month" do
        r = Review.new
        r.junior_consultant_id = 1

        r.review_type = "24-Month"

        r.valid?.should == true
    end
    it "disallows Review Type of 2-Month" do
        r = Review.new
        r.junior_consultant_id = 1

        r.review_type = "2-Month"

        r.valid?.should == false
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
end
