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
    render file: "#{Rails.root}/public/403", formats: [:html], :status => 403
  end

end
