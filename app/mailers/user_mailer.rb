class UserMailer < ActionMailer::Base

  def registration_confirmation(user)
    @user = user
    mail(:to => "<#{user.email}>", :subject => "You were registered on the ReviewSite")
  end

  def password_reset(user)
    @user = user
    mail(:to => "<#{user.email}>", :subject => "Recover account for the ReviewSite")
  end

  def new_feedback_notification(feedback)
    @feedback = feedback
    @review = feedback.review
    @reviewer = feedback.user
    @reviewee = @review.junior_consultant
    mail(:to => "<#{@reviewee.email}>", :subject => "You have new feedback")
  end

  def review_invitation(review, email, message)
    jc = review.junior_consultant
    @custom_message = message

    mail(:to => "<#{email}>", :subject => "You've been invited to give feedback for #{jc.name}.")
  end

  def feedback_reminder(invitation)
    @jc = invitation.reviewee
    @review = invitation.review
    @feedback = invitation.feedback
    mail(:to => "<#{invitation.email}>", :subject => "Please leave feedback for #{invitation.reviewee.name}.")
  end
end
