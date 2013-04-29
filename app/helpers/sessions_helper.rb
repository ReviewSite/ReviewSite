require 'rubycas-client'

module SessionsHelper
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end
  def signed_in?
    !current_user.nil?
  end
  def current_user=(user)
    @current_user = user
  end
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end
  def current_user?(user)
    user == current_user
  end
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end

  def local_sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def sign_out
    local_sign_out
    CASClient::Frameworks::Rails::Filter.logout(self)
  end

  def current_cas_user
    User.find_by_cas_name current_cas_name
  end

  def current_cas_name=(cas_name)
    session[:temp_cas_user] = cas_name
  end

  def current_cas_name
    session[:temp_cas_user] || session[:cas_user]
  end
end