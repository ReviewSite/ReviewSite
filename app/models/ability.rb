class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, [Review, ReviewingGroup, AssociateConsultant, User]
    end

    # User
    can(:create, User) if user.new_record?
    can [:show,
         :update,
         :feedbacks,
         :completed_feedback, 
         :add_email, 
         :remove_email], User, id: user.id

    # Invitation
    can :manage, Invitation do |invite|
      invite.review.upcoming? && review_participant?(invite.review, user)
    end

    if user.admin?
      can(:read, Invitation) { |invitation| invitation.review.upcoming? }
    end

    can [:read, :destroy], Invitation, email: user.email
    can [:read, :destroy], Invitation do |invite|
      sent_to_alias?(invite.review, user)
    end

    # Feedback
    can [:read, :update, :destroy], Feedback, submitted: false, user_id: user.id
    can [:summary, :index, :read],  Feedback, { submitted: true } if user.admin?

    can [:create, :new], Feedback do |feedback|
      feedback.review.upcoming? && (
      !feedback.review.invitations.where(email: user.email).empty? ||
      own_review?(feedback.review, user))
    end

    can :send_reminder, Feedback, review: { associate_consultant: { user_id: user.id } }
    can :send_reminder, Feedback, review: { associate_consultant: { coach_id: user.id } }
    can :read, Feedback, { submitted: true, user_id: user.id }
    can :read, Feedback, { submitted: true, review: { associate_consultant: { user_id: user.id } } }
    can :read, Feedback, { submitted: true, review: { associate_consultant: { coach_id: user.id } } }
    can :read, Feedback, { submitted: true, review: { associate_consultant: { reviewing_group_id: user.reviewing_group_ids } } }

    can [:create, :new], Feedback do |feedback|
      review = feedback.review
      review.invitations.where(email: user.email).any? ||
      (review.reviewee.id == user.id) ||
      sent_to_alias?(review, user)
    end

    can :preview, Feedback, user_id: user.id

    # Self Assessment
    can :manage, SelfAssessment do | self_assessment |
      (self_assessment.review_happened_recently? ||
      self_assessment.review.upcoming?) &&
      own_review?(self_assessment.review, user)
    end

    # Additional Email
    can :manage, AdditionalEmail

    # Review
    can [:summary, :read], Review, associate_consultant: { user_id: user.id }
    can [:summary, :read, :coachees], Review, associate_consultant: { coach_id: user.id }
    can [:summary, :read], Review, associate_consultant: { reviewing_group_id: user.reviewing_group_ids }
    can([:update], Review) do |review| 
      review.reviewee == user && review.in_the_future?
    end

  end

  private

  def review_participant?(review, user)
    own_review?(review, user) || coachee_review?(review, user)
  end

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
