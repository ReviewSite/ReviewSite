class ApplicationController < ActionController::Base
  before_filter :require_login

  check_authorization :unless => :devise_controller?
  protect_from_forgery
  include SessionsHelper


  def require_login
    unless session[:userinfo]
      store_location
      redirect_to "/auth/saml"
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    if signed_in?
      redirect_to root_url, :alert => exception.message
    end
  end

  def email_sent_for_unsubmitted_feedback(feedback)
    if feedback.submitted
      return false
    else
      if feedback.invitation
        invitation = feedback.invitation
      else
        review = feedback.review
        invitation = review.invitations.build(:email => @feedback.user.email)
      end
      send_reminder_email(invitation)
      return true
    end
  end

  def email_sent_for_unstarted_feedback(invitation)
    if invitation.feedback and invitation.feedback.submitted?
      return false
    else
      send_reminder_email(invitation)
      return true
    end
  end

  def send_reminder_email(invitation)
    UserMailer.feedback_reminder(invitation).deliver
  end
end
