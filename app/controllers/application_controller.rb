class ApplicationController < ActionController::Base
  before_filter :require_login
  before_filter :deny_json_access

  check_authorization
  protect_from_forgery
  include SessionsHelper


  def require_login
    unless session[:userinfo]
      store_location
      redirect_to "/auth/saml"
    end
  end

  def deny_json_access
    users1_path = "users/get_users.json"
    users2_path = "users.json"
    ac_path = "associate_consultants.json"
    # puts request.headers
    if (request.original_url.match(root_url + users1_path) ||
      request.original_url.match(root_url + ac_path) ||
      request.original_url.match(root_url + users2_path) ) && request.headers["QUERY_STRING"].empty?
      redirect_to root_url, alert: "You are not authorized to access this page."
    end
  end

  def path_valid?
    current_path == ("/reviews/new" || "/users/new")
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
