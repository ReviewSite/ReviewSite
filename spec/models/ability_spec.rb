require "spec_helper"
require "cancan/matchers"
describe Ability do
  let(:user) { FactoryGirl.create(:user) }
  let(:ac) { FactoryGirl.create(:associate_consultant, user: user) }
  let(:review) { FactoryGirl.create(:review, associate_consultant: ac) }
  let(:feedback) { FactoryGirl.create(:feedback, review: review) }
  let(:invitation) { FactoryGirl.create(:invitation, review: review) }

  describe "as an Admin" do
    subject { Ability.new(FactoryGirl.create(:admin_user)) }

    describe "dealing with Associate Consultant" do
      it { should be_able_to(:manage, AssociateConsultant) }
    end

    describe "dealing with Feedback" do
      it "should not be able to create additional feedback for user review" do
        should_not be_able_to(:create, review.feedbacks.build)
      end

      it "should not be able to view, update, or destroy "\
          "others' unsubmitted feedback" do
        should_not be_able_to(:read, feedback)
        should_not be_able_to(:update, feedback)
        should_not be_able_to(:destroy, feedback)
      end

      it "should be able to view, but not update or destroy "\
          "submitted feedback" do
        feedback.submitted = true
        should be_able_to(:read, feedback)
        should_not be_able_to(:update, feedback)
        should_not be_able_to(:destroy, feedback)
      end

      it "should be able to submit unsubmitted feedback" do
        should be_able_to(:submit, feedback)
        should_not be_able_to(:unsubmit, feedback)
      end

      it "should be able to unsubmit submitted feedback" do
        feedback.submitted = true
        should be_able_to(:unsubmit, feedback)
        should_not be_able_to(:submit, feedback)
      end

      it "should be able to send reminders on feedback" do
        should be_able_to(:send_reminder, feedback)
      end

      it "should not be able to send reminders on submitted feedback" do
        feedback.submitted = true
        should_not be_able_to(:send_reminder, feedback)
      end
    end

    describe "dealing with Invitation" do
      it { should be_able_to(:create, invitation) }
      it { should be_able_to(:send_reminder, invitation) }
      it { should be_able_to(:destroy, invitation) }
    end

    describe "dealing with Review" do
      it { should be_able_to(:manage, Review) }
      it { should be_able_to(:summary, Review) }
    end

    describe "dealing with Reviewing Group" do
      it { should be_able_to(:manage, ReviewingGroup) }
    end

    describe "dealing with Self Assessment" do
      it "should not be able to manage self assessments" do
        should_not be_able_to(:manage, review.self_assessments.new)
      end
    end

    describe "dealing with User" do
      it { should be_able_to(:manage, User) }
    end
  end

  describe "as a User" do
    subject { Ability.new(user) }

    describe "dealing with Associate Consultant" do
      it { should_not be_able_to(:manage, AssociateConsultant) }
    end

    describe "dealing with Feedback" do
      it "should be able to send reminders on feedback for own review" do
        should be_able_to(:send_reminder, feedback)
      end

      it "should not be able to view, update, or destroy "\
          "others' unsubmitted feedback" do
        should_not be_able_to(:read, feedback)
        should_not be_able_to(:update, feedback)
        should_not be_able_to(:destroy, feedback)
      end

      it "should allow users to create additional feedback for own reviews" do
        should be_able_to(:create, review.feedbacks.build)
      end

      it "should be able to read submitted feedback for own review" do
        feedback.submitted = true
        should be_able_to(:read, feedback)
      end

      it "should not be able to submit or unsubmit feedback" do
        should_not be_able_to(:submit, feedback)
        should_not be_able_to(:unsubmit, feedback)
      end
    end

    describe "dealing with Invitation" do
      it "should be able to manage invitation for own review" do
        invitation = FactoryGirl.create(:invitation, review: review)
        should be_able_to(:manage, invitation)
      end
    end

    describe "dealing with Review" do
      it { should_not be_able_to(:manage, Review) }
      it { should be_able_to(:update, Review) }

      it "should be able to view summary of own review" do
        should be_able_to(:summary, review)
      end
    end

    describe "dealing with Reviewing Group" do
      it { should_not be_able_to(:manage, ReviewingGroup) }
    end

    describe "dealing with Self-Assessment" do
      it "should only be able to manage self assessments for own reviews" do
        other_review = FactoryGirl.create(:review)
        should be_able_to(:manage, review.self_assessments.new)
        should_not be_able_to(:manage, other_review.self_assessments.new)
      end
    end

    describe "dealing with User" do
      it "should be able to view own user" do
        should_not be_able_to(:read, user)
      end

      it "should be able to update self" do
        should be_able_to(:update, user)
      end

      it "should not be able to destroy self" do
        should_not be_able_to(:destroy, user)
      end
    end
  end

  describe "as an Invited User" do
    let(:invited_user) { FactoryGirl.create(:user) }
    let!(:invitation) do
      FactoryGirl.create(:invitation, review: review, email: invited_user.email)
    end

    subject do
      Ability.new(invited_user)
    end

    it "should allow users to create feedback "\
        "for reviews they are invited to" do
      should be_able_to(:create, review.feedbacks.build)
    end

    it "should allow users to decline invitation" do
      should be_able_to(:destroy, invitation)
    end
  end

  describe "as an Alias-Invited User" do
    let!(:invited_user) { FactoryGirl.create(:user) }
    let!(:email_alias) { FactoryGirl.create(:additional_email,
      user: invited_user, email: "alias@thoughtworks.com",
        confirmed_at: Date.today) }
    let!(:invitation) { FactoryGirl.create(:invitation, review: review,
      email: email_alias.email) }

    subject do
      Ability.new(invited_user)
    end

    it "should allow users to create feedback "\
      "for invites sent to their email aliases" do
      should be_able_to(:create, review.feedbacks.build)
    end

    it "should allow users to decline invitation" do
      should be_able_to(:destroy, invitation)
    end
  end

  describe "as a User Giving Feedback" do
    subject { Ability.new(feedback.user) }

    describe "dealing with Invitation" do
      it "should be able to delete invitation" do

      end
    end

    describe "dealing with Feedback" do
      it "should be able to view, update, and destroy "\
          "own unsubmitted feedback" do
        should be_able_to(:read, feedback)
        should be_able_to(:update, feedback)
        should be_able_to(:destroy, feedback)
      end

      it "should be able to view, but not update, or destroy "\
          "submitted feedback" do
        feedback.submitted = true
        should be_able_to(:read, feedback)
        should_not be_able_to(:update, feedback)
        should_not be_able_to(:destroy, feedback)
      end
    end
  end

  describe "as a Coach" do
    subject { Ability.new(ac.coach) }

    describe "dealing with Feedback" do
      it "should be able to send reminders on feedback as coach of reviewee" do
        should be_able_to(:send_reminder, feedback)
      end

      it "should be able to read submitted feedback for coachee review" do
        feedback.submitted = true
        should be_able_to(:read, feedback)
      end
    end

    describe "dealing with Invitation" do
      it "should be able to manage invitation for coachee review" do
        invitation = FactoryGirl.create(:invitation, review: review)
        should be_able_to(:manage, invitation)
      end
    end
  end

  describe "as a Reviewing Group Member" do
    subject do
      reviewing_group_member = FactoryGirl.create(:user)
      ac.reviewing_group.users << reviewing_group_member
      Ability.new(reviewing_group_member)
    end

    describe "dealing with Feedback" do
      it "should be able to read submitted feedback "\
          "as reviewing group member" do
        feedback.submitted = true

        should be_able_to(:read, feedback)
      end
    end
  end

  describe "as a Non-User" do
    subject { Ability.new(nil) }

    describe "dealing with User" do
      it "should be able to create new user" do
        should be_able_to(:create, User)
      end
    end
  end

  describe "as an Other User" do
    subject { Ability.new(FactoryGirl.create(:user)) }

    describe "dealing with Feedback" do
      it "should not be able to send reminders on feedback "\
          "for others' reviews" do
        should_not be_able_to(:send_reminder, feedback)
      end

      it "should not be able to view, but not update, or destroy "\
          "submitted feedback" do
        feedback.submitted = true
        should_not be_able_to(:read, feedback)
        should_not be_able_to(:update, feedback)
        should_not be_able_to(:destroy, feedback)
      end
    end
  end
end
