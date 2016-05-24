require 'spec_helper'

describe "Invitation" do
  let (:ac) { create(:associate_consultant) }
  let (:review) { create(:review, associate_consultant: ac) }
  let (:invitation) { review.invitations.build(email: "review@thoughtworks.com") }
  subject { invitation }

  its(:email) { should == "review@thoughtworks.com"}
  its(:review) { should == review }
  its(:reviewee) { should == ac }
  it { should be_valid }

  describe "email" do
    it "should be present" do
      review.invitations.build(email: nil).should_not be_valid
    end

    it "should be formatted correctly" do
      review.invitations.build(email: "string").should_not be_valid
    end

    it "should be unique (ignoring case) for a review" do
      subject.save!
      review.invitations.build(email: "REVIEW@THOUGTWORKS.COM").should_not be_valid
    end

    it "doesn't need to be unique across reviews" do
      subject.save!
      other_review = create(:review)
      other_review.invitations.build(email: "review@thoughtworks.com").should be_valid
    end
  end

  describe "sent_date" do
    it "should have sent_date corresponding to created_at date" do
      subject.save!
      subject.sent_date.should == subject.created_at.to_date
    end
  end

  describe "feedback" do
    it "should be nil if no user matches email" do
      subject.feedback.should be_nil
    end

    it "should be the feedback that matches the review and user" do
      user = create(:user, email: invitation.email)
      feedback = create(:feedback, review: review, user: user)
      subject.feedback.should == feedback
    end
  end

  describe "sent_to?" do
    it "should be false if user's email doesn't match invitation's email" do
      subject.sent_to?( create(:user) ).should be false
    end

    it "should be true if user's email matches invitation's email" do
      subject.sent_to?( create(:user, email: invitation.email) ).should be true
    end

    it "should not be sent to nil" do
      subject.sent_to?(nil).should be false
    end
  end

  describe "expired?" do
    let (:user) { create(:user, email: subject.email) }

    it "should be false if feedback deadline has not passed and feedback is not submitted" do
      review.update_attribute(:feedback_deadline, Date.tomorrow)
      create(:feedback, review: review, user: user)
      subject.expired?.should be false
    end

    it "should be false if feedback deadline has not passed and feedback is submitted" do
      review.update_attribute(:feedback_deadline, Date.tomorrow)
      create(:submitted_feedback, review: review, user: user)
      subject.expired?.should be false
    end

    it "should be false if feedback deadline has passed and feedback is not submitted" do
      review.update_attribute(:feedback_deadline, Date.yesterday)
      create(:feedback, review: review, user: user)
      subject.expired?.should be false
    end

    it "should be false if feedback deadline has passed and feedback does not exist" do
      review.update_attribute(:feedback_deadline, Date.yesterday)
      subject.expired?.should be_falsey
    end

    it "should be true if feedback deadline has passed and feedback is submitted" do
      review.update_attribute(:feedback_deadline, Date.yesterday)
      create(:submitted_feedback, review: review, user: user)
      subject.expired?.should be true
    end
  end

  describe "delete" do
    it "should remove reference in review before deletion" do
      review.delete
    end
  end
end
