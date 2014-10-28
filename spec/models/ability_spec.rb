require 'spec_helper'
require 'cancan/matchers'
describe Ability do
  describe "Admin" do
    before do
      @admin_user = FactoryGirl.create(:admin_user)
      @ability = Ability.new(@admin_user)
    end
    subject{@ability}
    it{ should be_able_to(:manage, Review) }
    it{ should be_able_to(:manage, ReviewingGroup) }
    it{ should be_able_to(:manage, AssociateConsultant) }
    it{ should be_able_to(:manage, User) }
    it{ should be_able_to(:submit, Feedback) }
    it{ should be_able_to(:unsubmit, Feedback) }
    it{ should be_able_to(:summary, Review) }
    it{ should be_able_to(:read, Feedback) }
    it{ should be_able_to(:update, User)}
  end

  describe "User" do
    before do
      @user = FactoryGirl.create(:user)
      @ability = Ability.new(@user)
    end
    subject{@ability}
    it{ should_not be_able_to(:manage, Review) }
    it{ should_not be_able_to(:manage, ReviewingGroup) }
    it{ should_not be_able_to(:manage, AssociateConsultant) }
    it{ should_not be_able_to(:manage, User) }
    it{ should be_able_to(:manage, SelfAssessment) }
    it{ should_not be_able_to(:submit, Feedback) }
    it{ should_not be_able_to(:unsubmit, Feedback) }
    it{ should be_able_to(:summary, Review) }
    it{ should be_able_to(:read, Feedback) }
    it{ should be_able_to(:update, User)}
  end

  describe "User with review" do
    before do
      @user = FactoryGirl.create(:user)
      @admin_user = FactoryGirl.create(:admin_user)
      @ac = FactoryGirl.create(:associate_consultant, user: @user)
      @review = FactoryGirl.create(:review, associate_consultant: @ac)
      @ability = Ability.new(@user)
      @admin_ability = Ability.new(@admin_user)
    end

    it "should only be able to manage self assessments for own reviews" do
      @ability.should be_able_to(:manage, @review.self_assessments.new)
      other_review = FactoryGirl.create(:review)
      @ability.should_not be_able_to(:manage, other_review.self_assessments.new)
    end

    it "should allow users to create additional feedback for own reviews" do
      @ability.should be_able_to(:additional, Feedback.new, @review)
      @ability.should be_able_to(:create, Feedback.new, @review)
    end

    it "should allow users to create feedback for reviews they are invited to" do
      invited_user = FactoryGirl.create(:user)
      invitation = FactoryGirl.create(:invitation, review: @review, email: invited_user.email)
      invited_user_ability = Ability.new(invited_user)
      invited_user_ability.should be_able_to(:create, Feedback.new, @review)
    end

    it "should not let admin create additional feedback for user review" do
      @admin_ability.should_not be_able_to(:additional, Feedback.new, @review)
      @admin_ability.should_not be_able_to(:create, Feedback.new, @review)
    end

    it "should be able to view, update, and destroy own unsubmitted feedback" do
      feedback = FactoryGirl.create(:feedback, review: @review, submitted: false)
      giver_ability = Ability.new(feedback.user)
      giver_ability.should be_able_to(:read, feedback)
      giver_ability.should be_able_to(:update, feedback)
      giver_ability.should be_able_to(:destroy, feedback)
    end

    it "should not be able to view, update, or destroy others' unsubmitted feedback" do
      feedback = FactoryGirl.create(:feedback, review: @review, submitted: false)
      @ability.should_not be_able_to(:read, feedback)
      @admin_ability.should_not be_able_to(:read, feedback)
      @admin_ability.should_not be_able_to(:update, feedback)
      @admin_ability.should_not be_able_to(:destroy, feedback)
    end

    it "should be able to view, but not update, or destroy submitted feedback" do
      feedback = FactoryGirl.create(:feedback, review: @review, submitted: true)
      @admin_ability.should be_able_to(:read, feedback)
      @admin_ability.should_not be_able_to(:update, feedback)
      @admin_ability.should_not be_able_to(:destroy, feedback)
      giver_ability = Ability.new(feedback.user)
      giver_ability.should be_able_to(:read, feedback)
      giver_ability.should_not be_able_to(:update, feedback)
      giver_ability.should_not be_able_to(:destroy, feedback)
      other_user = FactoryGirl.create(:user)
      other_ability = Ability.new(other_user)
      other_ability.should_not be_able_to(:read, feedback)
      other_ability.should_not be_able_to(:update, feedback)
      other_ability.should_not be_able_to(:destroy, feedback)
    end

    it "should be able to read submitted feedback for own review" do
      feedback = FactoryGirl.create(:feedback, review: @review, submitted: true)
      @ability.should be_able_to(:read, feedback)
    end

    it "should be able to read submitted feedback for coachee review" do
      feedback = FactoryGirl.create(:feedback, review: @review, submitted: true)
      coach_ability = Ability.new(@ac.coach)
      coach_ability.should be_able_to(:read, feedback)
    end

    it "should be able to read submitted feedback as reviewing group member" do
      feedback = FactoryGirl.create(:feedback, review: @review, submitted: true)
      reviewing_group_member = FactoryGirl.create(:user)
      @ac.reviewing_group.users << reviewing_group_member
      reviewing_group_member_ability = Ability.new(reviewing_group_member)

      reviewing_group_member_ability.should be_able_to(:read, feedback)
    end

    it "should be able to send reminders on feedback as admin" do
      feedback = FactoryGirl.create(:feedback, review: @review)
      @admin_ability.should be_able_to(:send_reminder, feedback)
    end

    it "should be able to send reminders on feedback as coach of reviewee" do
      feedback = FactoryGirl.create(:feedback, review: @review)
      coach_ability = Ability.new(@ac.coach)
      coach_ability.should be_able_to(:send_reminder, feedback)
    end

    it "should be able to send reminders on feedback for own review" do
      feedback = FactoryGirl.create(:feedback, review: @review)
      @ability.should be_able_to(:send_reminder, feedback)
    end

    it "should not be able to send reminders on feedback for others' reviews" do
      feedback = FactoryGirl.create(:feedback)
      @ability.should_not be_able_to(:send_reminder, feedback)
    end
  end
end
