class Ability
  include CanCan::Ability

  def initialize(user)
    if user.nil?
      can :create, User
    else
      # signed in user
      if user.admin
        can :manage, Review
        can :manage, ReviewingGroup
        can :manage, JuniorConsultant
        can :manage, User
        can :manage, SelfAssessment
        can :manage, Invitation
      end

      can :manage, SelfAssessment do |self_assessment|
        is_user_the_jc_associated_with_review(user, self_assessment.review)
      end

      can :manage, Invitation do |invitation|
        is_user_the_jc_associated_with_review(user, invitation.review) or
        is_coach(user, invitation.review)
      end

      can :read, Invitation do |invitation|
        invitation.email == user.email
      end

      can :create, Feedback

      can :manage, Feedback do |feedback|
        # normal user can ONLY manage self if it's not submitted
        if (not feedback.submitted) and feedback.user == user
          true
        elsif user.admin
          # admin can manage submitted feedback
          feedback.submitted
        end
      end

      cannot :submit, Feedback
      cannot :unsubmit, Feedback
      if user.admin
        can :submit, Feedback do |feedback|
          not feedback.submitted
        end
        can :unsubmit, Feedback do |feedback|
          feedback.submitted
        end
      end

      can [:summary, :index, :read], Review do |review|
        is_user_the_jc_associated_with_review(user, review) or is_review_member(user, review) or is_coach(user, review)
      end

      can :read, Feedback do |feedback|
        is_user_the_feedback_giver(user, feedback) or (feedback.submitted and (is_user_the_jc_associated_with_review(user, feedback.review) or is_review_member(user, feedback.review) or is_coach(user,feedback.review)))
      end

      can [:update, :feedbacks], User do |the_user|
        the_user == user
      end
    end
  end



  private
  def is_user_the_feedback_giver(user, feedback)
    feedback.user == user
  end

  def is_coach(user, review)
    user == review.junior_consultant.coach
  end

  def is_user_the_jc_associated_with_review(user, review)
    user == review.junior_consultant.user
  end

  def is_review_member(user, review)
    reviewing_group_members = review.junior_consultant.try(:reviewing_group).try(:users)
    return false if reviewing_group_members.nil?
    reviewing_group_members.each do |reviewing_group_member|
      return true if reviewing_group_member == user
    end
    return false
  end
end
