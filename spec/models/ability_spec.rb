require "spec_helper"
require "cancan/matchers"
describe Ability do
  let(:user)       { create(:user) }
  let(:ac)         { create(:associate_consultant, user: user) }
  let(:review)     { create(:review, associate_consultant: ac) }
  let(:submitted)  { false }
  let(:feedback)   { create(:feedback, review: review, submitted: submitted) }
  let(:invitation) { create(:invitation, review: review) }

  describe "as an Admin" do
    subject { Ability.new(create(:admin)) }

    describe "dealing with Associate Consultant" do
      it { should be_able_to(:manage, AssociateConsultant) }
    end

    describe "dealing with Feedback" do
      it { should_not be_able_to(:create,        review.feedbacks.build) }
      it { should_not be_able_to(:read,          feedback) }
      it { should_not be_able_to(:update,        feedback) }
      it { should_not be_able_to(:destroy,       feedback) }
      it { should_not be_able_to(:submit,        feedback) }
      it { should_not be_able_to(:send_reminder, feedback) }

      describe "submitted feedback" do
        let(:submitted) { true }
        it { should     be_able_to(:read,          feedback) }
        it { should_not be_able_to(:update,        feedback) }
        it { should_not be_able_to(:destroy,       feedback) }
        it { should_not be_able_to(:submit,        feedback) }
        it { should_not be_able_to(:send_reminder, feedback) }
      end
    end

    describe "dealing with Invitation" do
      it { should_not be_able_to(:create,        invitation) }
      it { should_not be_able_to(:send_reminder, invitation) }
      it { should_not be_able_to(:destroy,       invitation) }
      it { should     be_able_to(:read,          invitation) }
    end

    describe "dealing with Review" do
      it { should be_able_to(:manage,  Review) }
      it { should be_able_to(:summary, Review) }
    end

    describe "dealing with Reviewing Group" do
      it { should be_able_to(:manage, ReviewingGroup) }
    end

    describe "dealing with Self Assessment" do
      it { should_not be_able_to(:manage, review.self_assessments.new) }
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
      describe "should be able to send reminders on feedback for own review" do
        it { should be_able_to(:send_reminder, feedback) }
      end

      describe "should not be able to view, update, or destroy "\
          "others' unsubmitted feedback" do
        it { should_not be_able_to(:read,    feedback) }
        it { should_not be_able_to(:update,  feedback) }
        it { should_not be_able_to(:destroy, feedback) }
      end

      describe "should allow users to create additional feedback for own reviews" do
        it { should be_able_to(:create, review.feedbacks.build) }
      end

      describe "should be able to read submitted feedback for own review" do
        let(:submitted) { true }
        it { should be_able_to(:read, feedback) }
      end

      describe "should not be able to submit or unsubmit feedback" do
        it { should_not be_able_to(:submit,   feedback) }
        it { should_not be_able_to(:unsubmit, feedback) }
      end
    end

    describe "dealing with Invitation" do
      it "should be able to manage invitation for own review" do
        invitation = create(:invitation, review: review)
        should be_able_to(:manage, invitation)
      end
    end

    describe "dealing with Review" do
      it { should_not be_able_to(:manage, Review) }
      it { should be_able_to(:update, Review) }

      describe "should be able to view summary of own review" do
        it { should be_able_to(:summary, review) }
      end
    end

    describe "dealing with Reviewing Group" do
      it { should_not be_able_to(:manage, ReviewingGroup) }
    end

    describe "dealing with Self-Assessment" do
      it "should only be able to manage self assessments for own reviews" do
        other_review = create(:review)
        should be_able_to(:manage, review.self_assessments.new)
        should_not be_able_to(:manage, other_review.self_assessments.new)
      end
    end

    describe "dealing with User" do
      it "should be able to view own user" do
        should be_able_to(:show, user)
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
    let(:invited_user) { build(:user) }
    let!(:invitation) { create(:invitation, review: review, email: invited_user.email) }

    subject { Ability.new(invited_user) }

    it "should allow users to create feedback "\
        "for reviews they are invited to" do
      should be_able_to(:create, review.feedbacks.build)
    end

    it "should allow users to decline invitation" do
      should be_able_to(:destroy, invitation)
    end
  end

  describe "as an Alias-Invited User" do
    let!(:invited_user) { create(:user) }
    let!(:email_alias) { create(:additional_email,
      user: invited_user, email: "alias@thoughtworks.com",
        confirmed_at: Date.today) }
    let!(:invitation) { create(:invitation, review: review,
      email: email_alias.email) }

    subject { Ability.new(invited_user) }

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

    describe "dealing with Reviews" do
      it "should be able to view coachees reviews" do
        should be_able_to(:coachees, review)
      end
    end

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
        invitation = create(:invitation, review: review)
        should be_able_to(:manage, invitation)
      end
    end
  end

  describe "as a Reviewing Group Member" do
    subject do
      reviewing_group_member = create(:user)
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
    subject { Ability.new(build(:user)) }

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
