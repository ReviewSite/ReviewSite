class ApplicationController < ActionController::Base
  before_filter :require_login

  check_authorization
  protect_from_forgery
  include SessionsHelper


  def require_login
    unless session[:userinfo]
      store_location
      redirect_to "/auth/saml"
    end
  end

  def deny_users_json_access
    unless request.referer.match(root_url + "/users/get_users.json")
      redirect_to root_url, alert: "You are not authorized to access this page."
    end
  end

  def deny_acs_json_access
    unless request.referer.match(root_url + "/associate_consultants.json")
      redirect_to root_url, alert: "You are not authorized to access this page."
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    if signed_in?
      redirect_to root_url, :alert => exception.message
    else
      redirect_to signin_path, alert: "You must be signed in to access this page"
      store_location
    end
  end
end
