require "spec_helper"
require "cancan/matchers"
describe Ability do
  let(:user) { FactoryGirl.create(:user) }
  let(:ac) { FactoryGirl.create(:associate_consultant, user: user) }
  let(:review) { FactoryGirl.create(:review, associate_consultant: ac) }
  let(:feedback) { FactoryGirl.create(:feedback, review: review) }

  describe "Admin" do
    subject { Ability.new(FactoryGirl.create(:admin_user)) }

    it { should be_able_to(:manage, Review) }
    it { should be_able_to(:manage, ReviewingGroup) }
    it { should be_able_to(:manage, AssociateConsultant) }
    it { should be_able_to(:manage, User) }
    it { should be_able_to(:submit, Feedback) }
    it { should be_able_to(:unsubmit, Feedback) }
    it { should be_able_to(:summary, Review) }
    it { should be_able_to(:read, Feedback) }
    it { should be_able_to(:update, User) }

    it "should not be able to create additional feedback for user review" do
      should_not be_able_to(:additional, review.feedbacks.build)
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

    it "should be able to send reminders on feedback" do
      should be_able_to(:send_reminder, feedback)
    end
  end

  describe "User" do
    subject { Ability.new(user) }

    it { should_not be_able_to(:manage, Review) }
    it { should_not be_able_to(:manage, ReviewingGroup) }
    it { should_not be_able_to(:manage, AssociateConsultant) }
    it { should_not be_able_to(:manage, User) }
    it { should be_able_to(:manage, SelfAssessment) }
    it { should_not be_able_to(:submit, Feedback) }
    it { should_not be_able_to(:unsubmit, Feedback) }
    it { should be_able_to(:summary, Review) }
    it { should be_able_to(:read, Feedback) }
    it { should be_able_to(:update, User) }

    it "should be able to send reminders on feedback for own review" do
      should be_able_to(:send_reminder, feedback)
    end

    it "should not be able to view, update, or destroy "\
        "others' unsubmitted feedback" do
      should_not be_able_to(:read, feedback)
      should_not be_able_to(:update, feedback)
      should_not be_able_to(:destroy, feedback)
    end

    it "should only be able to manage self assessments for own reviews" do
      other_review = FactoryGirl.create(:review)
      should be_able_to(:manage, review.self_assessments.new)
      should_not be_able_to(:manage, other_review.self_assessments.new)
    end

    it "should allow users to create additional feedback for own reviews" do
      should be_able_to(:create, review.feedbacks.build)
    end

    it "should be able to read submitted feedback for own review" do
      feedback.submitted = true
      should be_able_to(:read, feedback)
    end
  end

  describe "User giving feedback" do
    subject { Ability.new(feedback.user) }

    it "should allow users to create feedback "\
        "for reviews they are invited to" do
      invited_user = FactoryGirl.create(:user)
      FactoryGirl.create(
        :invitation,
        review: review,
        email: invited_user.email)
      invited_user_ability = Ability.new(invited_user)
      invited_user_ability.should be_able_to(:create, review.feedbacks.build)
    end

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

  describe "Coach" do
    subject { Ability.new(ac.coach) }

    it "should be able to send reminders on feedback as coach of reviewee" do
      should be_able_to(:send_reminder, feedback)
    end

    it "should be able to read submitted feedback for coachee review" do
      feedback.submitted = true
      should be_able_to(:read, feedback)
    end
  end

  describe "Reviewing Group Member" do
    subject do
      reviewing_group_member = FactoryGirl.create(:user)
      ac.reviewing_group.users << reviewing_group_member
      Ability.new(reviewing_group_member)
    end

    it "should be able to read submitted feedback "\
        "as reviewing group member" do
      feedback.submitted = true

      should be_able_to(:read, feedback)
    end
  end

  describe "Other User" do
    subject { Ability.new(FactoryGirl.create(:user)) }

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
