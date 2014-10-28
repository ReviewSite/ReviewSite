class Ability
  include CanCan::Ability

  def initialize(user, ability_review = nil)

    alias_action :create, :read, :update, :destroy, :to => :crud

    if user.nil?
      can :create, User
    else

    # baseline
    can :manage, SelfAssessment, :review => { :associate_consultant => { :user_id => user.id } }

    can :manage, Invitation, :review => { :associate_consultant => { :user_id => user.id } }
    can :manage, Invitation, :review => { :associate_consultant => { :coach_id => user.id } }
    can [:read, :destroy], Invitation, :email => user.email

    can [:read, :update, :destroy], Feedback, { :submitted => false, :user_id => user.id }

    can [:create, :new], Feedback do |feedback, review = ability_review |
      !review.invitations.where(email: user.email).empty? || (review.associate_consultant.user.id == user.id)
    end

    can :additional, Feedback do |feedback, review = ability_review|
      review.associate_consultant.user.id == user.id
    end

    can :send_reminder, Feedback, :review => { :associate_consultant =>
      { :user_id => user.id } }
    can :send_reminder, Feedback, :review => { :associate_consultant =>
      { :coach_id => user.id } }
    cannot :submit, Feedback # only admins can use "submit"/"unsubmit" functions in controller
    cannot :unsubmit, Feedback
    can :read, Feedback, { :submitted => true, :user_id => user.id }
    can :read, Feedback, { :submitted => true, :review => { :associate_consultant => { :user_id => user.id } } }
    can :read, Feedback, { :submitted => true, :review => { :associate_consultant => { :coach_id => user.id } } }
    can :read, Feedback, { :submitted => true, :review => { :associate_consultant => { :reviewing_group_id => user.reviewing_group_ids } } }

    can [:summary, :index, :read], Review, :associate_consultant => { :user_id => user.id }
    can [:summary, :index, :read], Review, :associate_consultant => { :coach_id => user.id }
    can [:summary, :index, :read], Review, :associate_consultant => { :reviewing_group_id => user.reviewing_group_ids }

    can [:update, :feedbacks, :completed_feedback], User, :id => user.id

    # admin permissions
      if user.admin
        can :manage, Review
        can :manage, ReviewingGroup
        can :manage, AssociateConsultant
        can :manage, User
        can :manage, Invitation
        can [:summary, :index, :read], Feedback, { submitted: true }
        can :send_reminder, Feedback, { submitted: false }
        can :submit, Feedback do |feedback|
          not feedback.submitted
        end
        can :unsubmit, Feedback do |feedback|
          feedback.submitted
        end
      end
    end
  end
end
