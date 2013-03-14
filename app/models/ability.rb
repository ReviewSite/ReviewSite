class Ability
  include CanCan::Ability

  def initialize(user)
    unless user.nil?
      # signed in user
      if user.admin
        can :manage, Review
        can :manage, ReviewingGroup
        can :manage, ReviewingGroupMember
        can :manage, JuniorConsultant
        can :manage, User
        can :manage, SelfAssessment
      end

      can :manage, SelfAssessment do |self_assessment|
        self_assessment.review.junior_consultant.email == user.email
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

      cannot :summary, Review
      if user.admin
        can :summary, Review do |review|
          res = false
          review.feedbacks.each do |feedback|
            if can? :read, feedback
              res = true
            end
          end
          res
        end
      else
        can :summary, Review do |review|
          is_user_the_jc_associated_with_review(user, review) or is_review_member(user, review) or is_coach(user, review)
        end

      end

      can :read, Feedback do |feedback|
        is_user_the_feedback_giver(user, feedback) or (feedback.submitted and (is_user_the_jc_associated_with_review(user, feedback.review) or is_review_member(user, feedback.review) or is_coach(user,feedback.review)))
      end

      can [:update], User do |the_user|
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
    user.email == review.junior_consultant.email
  end

  def is_review_member(user, review)
    reviewing_group_members = review.junior_consultant.try(:reviewing_group).try(:reviewing_group_members)
    return false if reviewing_group_members.nil?
    reviewing_group_members.each do |reviewing_group_member|
      return true if reviewing_group_member.user == user
    end
    return false
  end
end
