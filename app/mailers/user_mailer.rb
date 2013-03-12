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
    @user = feedback.user
    mail(:to => "#{@user.name} <#{@user.email}>", :subject => "You submitted feedback")
  end
end
