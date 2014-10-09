class Ability
  include CanCan::Ability

  def initialize(user)

    alias_action :create, :read, :update, :destroy, :to => :crud

    if user.nil?
      can :create, User
    else

    # baseline
    can :manage, SelfAssessment, :review => { :associate_consultant => { :user_id => user.id } }

    can :manage, Invitation, :review => { :associate_consultant => { :user_id => user.id } }
    can :manage, Invitation, :review => { :associate_consultant => { :coach_id => user.id } }
    can [:read, :destroy], Invitation, :email => user.email

    can :create, Feedback
    can :manage, Feedback, { :submitted => false, :user_id => user.id }
    can :send_reminder, Feedback, { :review=> { :associate_consultant =>
      { :user_id => user.id } } }
    cannot :submit, Feedback
    cannot :unsubmit, Feedback
    can :read, Feedback, :user_id => user.id
    can :read, Feedback, { :submitted => true, :review => { :associate_consultant => { :user_id => user.id } } }
    can :read, Feedback, { :submitted => true, :review => { :associate_consultant => { :coach_id => user.id } } }
    can :read, Feedback, { :submitted => true, :review => { :associate_consultant => { :reviewing_group_id => user.reviewing_group_ids } } }

    can [:summary, :index, :read], Review, :associate_consultant => { :user_id => user.id }
    can [:summary, :index, :read], Review, :associate_consultant => { :coach_id => user.id }
    can [:summary, :index, :read], Review, :associate_consultant => { :reviewing_group_id => user.reviewing_group_ids }

    can [:update, :feedbacks], User, :id => user.id

    # admin permissions
      if user.admin
        can :manage, Review
        can :manage, ReviewingGroup
        can :manage, AssociateConsultant
        can :manage, User
        can :manage, SelfAssessment
        can :manage, Invitation
        can [:summary, :index, :read, :create, :new], Feedback, { submitted: true }
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
