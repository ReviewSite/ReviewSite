class Ability
  include CanCan::Ability

  def initialize(user)

    alias_action :create, :read, :update, :destroy, to: :crud

    if user.nil?
      can :create, User
    else
      # baseline
      can :manage, SelfAssessment do | self_assessment |
        (self_assessment.review_happened_recently? ||
        self_assessment.review.upcoming?) &&
        own_review?(self_assessment.review, user)
      end

      can :manage, Invitation do | invitation |
        invitation.review.upcoming? &&
        (own_review?(invitation.review, user) ||
        coachee_review?(invitation.review, user))
      end

      can [:read, :destroy], Invitation, email: user.email
      can [:read, :destroy], Invitation do |invite|
        sent_to_alias?(invite.review, user)
      end

      can [:read, :update, :destroy], Feedback, submitted: false, user_id: user.id

      can [:create, :new], Feedback do | feedback |
        feedback.review.upcoming? && (
        !feedback.review.invitations.where(email: user.email).empty? ||
        own_review?(feedback.review, user))
      end

      can :manage, AdditionalEmail

      can [:create, :new, :preview], Feedback do |feedback|
        review = feedback.review
        !review.invitations.where(email: user.email).empty? || (review.associate_consultant.user.id == user.id) ||
        sent_to_alias?(review, user)
      end

      can :send_reminder, Feedback, :review => { :associate_consultant =>
        { :user_id => user.id } }
      can :send_reminder, Feedback, :review => { :associate_consultant =>
        { :coach_id => user.id } }
      can :read, Feedback, { :submitted => true, :user_id => user.id }
      can :read, Feedback, { :submitted => true, :review => { :associate_consultant => { :user_id => user.id } } }
      can :read, Feedback, { :submitted => true, :review => { :associate_consultant => { :coach_id => user.id } } }
      can :read, Feedback, { :submitted => true, :review => { :associate_consultant => { :reviewing_group_id => user.reviewing_group_ids } } }

      can [:summary, :read], Review, :associate_consultant => { :user_id => user.id }
      can [:summary, :read, :coachees], Review, :associate_consultant => { :coach_id => user.id }
      can [:summary, :read], Review, :associate_consultant => { :reviewing_group_id => user.reviewing_group_ids }
      can [:update], Review do |review|
        review.associate_consultant.user == user && review.review_date > Date.today
      end

      can [:show, :update, :feedbacks, :completed_feedback, :add_email, :remove_email], User, :id => user.id

      # admin permissions
      if user.admin
        can :manage, Review
        can :manage, ReviewingGroup
        can :manage, AssociateConsultant
        can :manage, User
        can :read, Invitation do |invitation|
          invitation.review.upcoming?
        end
        can [:summary, :index, :read], Feedback, { submitted: true }
      end
    end
  end

  private

  def own_review?(review, user)
    review.associate_consultant.user_id == user.id
  end

  def coachee_review?(review, user)
    review.associate_consultant.coach_id == user.id
  end

  def sent_to_alias?(review, user)
    invited_emails = review.invitations.collect { |i| i.email }
    user_emails = user.additional_emails.collect { |e| e.email }
    !(invited_emails & user_emails).empty?
  end
end
