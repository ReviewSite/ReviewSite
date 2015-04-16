require 'spec_helper'

describe AssociateConsultant do
  before do
    user = FactoryGirl.create(:user, name: "Example User")
    coach = FactoryGirl.create(:user)
    @ac = FactoryGirl.build(:associate_consultant, :coach => coach, :user => user)
  end

  subject { @ac }
  it{ @ac.to_s.should == "Example User" }

  it{ should respond_to(:notes)}
  it{ should respond_to(:reviewing_group_id)}
  it{ should respond_to(:coach_id)}

  describe "has associations" do
    it { should belong_to(:user) }
  end

  it "can graduate" do
    graduate_ac = FactoryGirl.create(:graduated_ac)
    graduate_ac.graduate
    graduate_ac.graduated.should == true
  end

  it "can have a reviewing group" do
    @ac.reviewing_group = FactoryGirl.create(:reviewing_group)
    @ac.valid?.should == true
  end

  it "shouldn't be valid with invalid coach id" do
    @ac.coach_id = "some"
    @ac.valid?.should == false
  end

  it "shouldn't be valid with invalid reviewing group" do
    @ac.reviewing_group = nil
    @ac.valid?.should == false
    @ac.errors[:reviewing_group_id].should include("can't be blank.")
  end

  it "should be valid with valid coach id" do
    @ac.coach_id = 1
    @ac.valid?.should == true
  end

  describe "with reviews" do
    before(:each) do
      @ac = FactoryGirl.create(:associate_consultant)
      @review = FactoryGirl.create(:review, :associate_consultant => @ac, :review_type => "6-Month", :review_date => Date.today - 5.days)
    end

    it "should delete the review when the associate consultant is deleted" do
      Review.all.count.should == 1
      @ac.destroy
      Review.all.count.should == 0
    end

    it "should return only the most recent review" do
      latest_review = FactoryGirl.create(:new_review_type, :associate_consultant => @ac, :review_type => "12-Month")
      @ac.reviews.count.should eq(2)

      @ac.upcoming_review.should eq(latest_review)
    end

    it "should return only the future review closest to today" do
      upcoming_review = FactoryGirl.create(:new_review_type, :associate_consultant => @ac, :review_type => "12-Month", :review_date => Date.today + 5.months)
      review18 = FactoryGirl.create(:new_review_type, :associate_consultant => @ac, :review_type => "18-Month", :review_date => Date.today + 12.months)

      @ac.reviews.count.should eq(3)
      @ac.upcoming_review.should eq(upcoming_review)
    end

  end
end
