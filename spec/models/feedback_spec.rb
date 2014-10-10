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

  it "cannot create 2nd feedback for the same review/user combination" do
    old_f = FactoryGirl.create(:feedback)
    new_f = FactoryGirl.build(:feedback)

    new_f.valid?.should ==  true

    new_f.user = old_f.user

    new_f.valid?.should == true

    new_f.review = old_f.review

    new_f.valid?.should == false
  end

  it "can have a user_strincg instead of a user_id" do
    new_f = FactoryGirl.build(:feedback)

    new_f.user_id = nil
    new_f.user_string = "Jane Doe"
    new_f.valid?.should == false

    new_f.user_id = 1
    new_f.valid?.should == true
  end

  it "has the user's name for the reviewed" do
    new_f = FactoryGirl.create(:feedback)
    new_f.reviewer.should == new_f.user.name
  end

  it "has the customer user_string for the reviewer" do
    new_f = FactoryGirl.create(:feedback, :user_string => "Holly")
    new_f.reviewer.should == "Holly"
  end

  describe "submit_final" do
    let(:coach) { FactoryGirl.create(:coach) }
    let(:ac) { FactoryGirl.create(:associate_consultant, coach: coach) }
    let(:review) { FactoryGirl.create(:review, associate_consultant: ac) }
    subject { FactoryGirl.build(:feedback, id: 1, review: review,
      user: ac.user) }

    it "sends notification email" do
      UserMailer.should_receive(:new_feedback_notification).and_return(double(deliver: true))
      UserMailer.should_receive(:new_feedback_notification_coach).and_return(double(deliver: true))
      subject.submit_final
    end

    it "does not send notification email when coach does not exist" do
      UserMailer.should_not_receive(:new_feedback_notification_coach)
      subject.review.associate_consultant.coach = nil
      subject.submit_final
    end

    it "sets submitted to true" do
      subject.save!
      expect do
        subject.submit_final
        subject.reload
      end.to change { subject.submitted }.from(false).to(true)
    end
  end
end
