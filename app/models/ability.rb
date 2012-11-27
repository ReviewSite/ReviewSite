class Ability
  include CanCan::Ability

  def is_review_member(user, r)
    rgms = r.junior_consultant.try(:reviewing_group).try(:reviewing_group_members)
    if rgms.nil?
      return false
    end
    rgms.each do |rgm|
      if rgm.user == user
        return true
      end
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

      can :manage, Feedback do |f|
        # normal user can ONLY manage self if it's not submitted
        if (not f.submitted) and f.user == user
          true
        elsif user.admin 
          # admin can manage submitted feedback
          f.submitted
        end
      end

      cannot :submit, Feedback
      cannot :unsubmit, Feedback
      if user.admin 
        can :submit, Feedback do |f|
          ! f.submitted
        end
        can :unsubmit, Feedback do |f|
          f.submitted
        end
      end

      cannot :summary, Review
      if user.admin
        can :summary, Review do |r|
          res = false
          r.feedbacks.each do |f|
            if can? :read, f
              res = true
            end
          end
          res
        end
      else 
        can :summary, Review do |r|
          user.email == r.junior_consultant.email or is_review_member(user, r)
        end
      end

      can :read, Feedback do |f|
        f.user == user or (f.submitted and (user.email == f.review.junior_consultant.email or is_review_member(user, f.review)))
      end

      can [:update, :read], User do |u|
        u == user
      end
    end
  end
end
