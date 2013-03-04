class UserMailer < ActionMailer::Base
  default :from => "do-not-reply@thoughtworks.com"

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
end