class UserMailer < ActionMailer::Base

  def self_registration_confirmation(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Thank you for registering on the ReviewSite")
  end

  def admin_registration_confirmation(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "You were registered on the ReviewSite")
  end

  def password_reset(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Reset password for the ReviewSite")
  end

  def new_feedback_notification(feedback)
    @feedback = feedback
    @review = feedback.review
    @reviewer = feedback.user
    @reviewee = @review.junior_consultant
    mail(:to => "#{@reviewee.name} <#{@reviewee.email}>", :subject => "You have new feedback")
  end
end
