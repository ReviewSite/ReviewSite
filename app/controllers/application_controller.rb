class ApplicationController < ActionController::Base
  before_filter CASClient::Frameworks::Rails::Filter
  before_filter :login_from_cas

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

  def login_from_cas
    if current_cas_user and not signed_in?
      sign_in current_cas_user 
    end
  end
end
