class UserMailer < ActionMailer::Base
  @my_tw_url = "https://thoughtworks.jiveon.com/groups/review-site-support"
  @@donotreply = "<do-not-reply@thoughtworks.org>"

  def self.my_tw_url
    @my_tw_url
  end

  def registration_confirmation(user)
    @user = user
    mail(to: "<#{user.email}>", from: @@donotreply,
      subject: "[ReviewSite] You were registered!")
  end

  def review_creation(review)
    @review = review
    @ac_name = review.reviewee.name
    @ac_email = review.reviewee.email
    @review_type = review.review_type
    @review_date = review.review_date
    @feedback_deadline = review.feedback_deadline
    mail(to: "<#{@ac_email}>", from: @@donotreply,
      subject: "[ReviewSite] Your #{@review_type} review has been created")
  end

  def reviews_creation(next_review)
    @next_review = next_review
    @ac_name = next_review.reviewee.name
    @ac_email = next_review.reviewee.email
    mail(to: "<#{@ac_email}>", from: @@donotreply,
      subject: "[ReviewSite] Reviews have been created for you")
  end

  def review_update(invitee, review)
    @feedback_deadline = review.feedback_deadline
    @ac_name = review.reviewee.name
    mail(to: "<#{invitee.email}>", from: @@donotreply,
      subject: "[ReviewSite] #{@ac_name}'s review has been updated")
  end

  def new_feedback_notification(feedback)
    @feedback = feedback
    @review = feedback.review
    @reviewer = feedback.user
    @reviewee = @review.associate_consultant
    mail(to: "<#{@reviewee.user.email}>", from: @@donotreply,
      subject: "[ReviewSite] You have new feedback from #{@reviewer}")
  end

  def new_feedback_notification_coach(feedback)
    @feedback = feedback
    @review = feedback.review
    @reviewer = feedback.user
    @reviewee = @review.associate_consultant
    @coach = @reviewee.coach unless @reviewee.coach.nil?
    mail(to: "<#{@coach.email}>", from: @@donotreply,
      subject: "[ReviewSite] Your coachee, #{@reviewee}, has new feedback from #{@reviewer}")
  end

  def review_invitation(review, email, message)
    ac = review.associate_consultant
    @custom_message = message

    mail( to: "<#{email}>",
          from: @@donotreply,
          subject: "[ReviewSite] You've been invited to give feedback for #{ac.user.name}")
  end

  def review_invitation_AC_copy(review, message, successful_emails)
    @ac = review.associate_consultant
    @custom_message = message
    @emails = successful_emails

    mail( to: "<#{@ac.user.email}>",
          from: @@donotreply,
          subject: "[ReviewSite] Here's a copy of your request for feedback"
        )
  end

  def reminder_for_invitation(invitation)
    @ac = invitation.reviewee
    @review = invitation.review
    @feedback = invitation.feedback
    mail(to: "<#{invitation.email}>", from: @@donotreply, subject: "[ReviewSite] Please leave feedback for #{@ac.user.name}")
  end

  def reminder_for_feedback(feedback)
    @ac = feedback.review.associate_consultant
    @review = feedback.review
    @feedback = feedback
    mail(to: "<#{feedback.user.email}>", from: @@donotreply, subject: "[ReviewSite] Please leave feedback for #{@ac.user.name}")
  end

  def feedback_declined(invitation)
    @invitation = invitation
    @review = invitation.review
    mail(
      to: "<#{invitation.reviewee.user.email}>",
      from: @@donotreply,
      subject:
        "[ReviewSite] #{invitation.email} has declined your feedback request")
  end
end
