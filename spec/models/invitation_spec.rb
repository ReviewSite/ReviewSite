require 'spec_helper'

describe "Invitation" do
  let (:review) { FactoryGirl.create(:review) }
  subject { review.invitations.build(email: "review@example.com") }

  its(:email) { should == "review@example.com"}
  its(:review) { should == review }
end