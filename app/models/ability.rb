class Ability
  include CanCan::Ability

  def is_review_member(user, review)
    reviewing_group_members = review.junior_consultant.try(:reviewing_group).try(:reviewing_group_members)
    return false if reviewing_group_members.nil?
    reviewing_group_members.each do |reviewing_group_member|
      return true if reviewing_group_member.user == user
    end
    return false
  end

  def initialize(user)
    unless user.nil?
      # signed in user
      if user.admin
        can :manage, Review
        can :manage, ReviewingGroup
        can :manage, ReviewingGroupMember
        can :manage, JuniorConsultant
        can :manage, User
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
          user.email == review.junior_consultant.email or is_review_member(user, review)
        end
      end

      can :read, Feedback do |feedback|
        feedback.user == user or (feedback.submitted and (user.email == feedback.review.junior_consultant.email or is_review_member(user, feedback.review)))
      end

      can [:update, :read], User do |user|
        user == user
      end
    end
  end
end
