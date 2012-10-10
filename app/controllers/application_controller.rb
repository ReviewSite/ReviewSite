class ApplicationController < ActionController::Base
  check_authorization
  protect_from_forgery
  include SessionsHelper

  rescue_from CanCan::AccessDenied do |exception|
    if signed_in?
      redirect_to root_url, :alert => exception.message
    else
      redirect_to signin_url, :alert => exception.message
      store_location
    end
  end
end
