require 'rubycas-client'

module SessionsHelper
  def signed_in?
    !current_user.nil?
  end

  def current_user
    @current_user || reset_current_user
  end

  def reset_current_user
    @current_user = User.find_by_cas_name( current_cas_name )
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end

  def sign_out
    CASClient::Frameworks::Rails::Filter.logout(self)
  end

  def current_cas_name=(cas_name)
    session[:temp_cas_user] = cas_name
  end

  def current_cas_name
    if ENV['CAS-TEST-MODE']
      session[:temp_cas_user] || session[:cas_user]
    else
      session[:cas_user]
    end
  end
end