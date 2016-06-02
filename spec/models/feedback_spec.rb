require 'spec_helper'

def build_new_valid_feedback (attributes={})
  feedback = build(:feedback)
  attributes.each do |property_name, property_value|
    feedback.send("#{property_name}=", property_value)
  end
  feedback
end

describe Feedback do
  it "has a review" do
    f = Feedback.new(:project_worked_on => "Gotham", :role_description => "Batman")
    f.user = create(:user)
    f.valid?.should == false

    f.review = create(:review)

    f.valid?.should == true
  end

  it "has a user" do
    f = Feedback.new(:project_worked_on => "Gotham", :role_description => "Batman")
    f.review = create(:review)
    f.valid?.should == false

    f.user = create(:user)

    f.valid?.should == true
  end

  it "has a role description" do
    feedback = Feedback.new(:project_worked_on => "Garbage Can")
    feedback.review = create(:review)
    feedback.user = create(:user)
    feedback.valid?.should == false

    feedback.role_description = "Fire Starter"
    feedback.valid?.should == true
  end

  it "has a project worked on" do
    feedback = Feedback.new(:role_description => "Fire Starter")
    feedback.review = create(:review)
    feedback.user = create(:user)
    feedback.valid?.should == false

    feedback.project_worked_on = "Garbage Can"
    feedback.valid?.should == true
  end

  it "cannot create 2nd feedback for the same review/user combination" do
    old_f = build_new_valid_feedback
    old_f.save
    new_f = build_new_valid_feedback

    new_f.valid?.should ==  true

    new_f.user = old_f.user

    new_f.valid?.should == true

    new_f.review = old_f.review

    new_f.valid?.should == false
  end

  it "can have a user_string instead of a user_id" do
    new_f = build_new_valid_feedback
    new_f.user_id = nil
    new_f.user_string = "Jane Doe"
    new_f.valid?.should == false

    new_f.user_id = 1
    new_f.valid?.should == true
  end

  it "has the user's name for the reviewed" do
    new_f = build_new_valid_feedback
    new_f.save
    new_f.reviewer.should == new_f.user.name
  end

  it "has the customer user_string for the reviewer" do
    new_f = build_new_valid_feedback({ user_string: "Holly" })
    new_f.reviewer.should == "Holly"
  end

  describe "submit_final" do
    let(:coach) { create(:coach) }
    let(:ac) { create(:associate_consultant, coach: coach) }
    let(:review) { create(:review, associate_consultant: ac) }
    subject { build_new_valid_feedback( { id: 1, review: review,
      user: ac.user }) }

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

    it "does not send notification to self for self-reported feedback" do
      UserMailer.should_not_receive(:new_feedback_notification)
      subject.reported_by = Feedback::SELF_REPORTED
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
