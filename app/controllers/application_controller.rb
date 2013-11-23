class ApplicationController < ActionController::Base
  before_filter CASClient::Frameworks::Rails::Filter

  check_authorization
  protect_from_forgery
  include SessionsHelper

  rescue_from CanCan::AccessDenied do |exception|
    if signed_in?
      redirect_to root_url, :alert => exception.message
    else
      redirect_to signin_path, alert: "You must be signed in to access this page"
      store_location
    end
  end      

  def select_view_for_review_id(id)
    if id < 2
      'old_' + params[:action]
    else
      params[:action]
    end
  end
end
