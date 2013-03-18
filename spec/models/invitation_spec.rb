require 'spec_helper'

describe "Invitation" do
  let (:review) { FactoryGirl.create(:review) }
  subject { review.invitations.build(email: "review@example.com") }

  its(:email) { should == "review@example.com"}
  its(:review) { should == review }
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
      review.invitations.build(email: "REVIEW@EXAMPLE.COM").should_not be_valid
    end

    it "doesn't need to be unique across reviews" do
      subject.save!
      other_review = FactoryGirl.create(:review)
      other_review.invitations.build(email: "review@example.com").should be_valid
    end
  end 
end