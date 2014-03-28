module SessionsHelper
  def first_time_sign_in(user)
    user.update_attribute(:cas_name, current_cas_name)
    flash[:notice] = "From now on, we will sign you in automatically via CAS."
    redirect_back_or(root_url)
  end

  def signed_in?
    not current_user.nil?
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
    session[:userinfo] = nil
    redirect_to "https://thoughtworks.oktapreview.com/login/signout?fromURI=#{ENV['URL']}"
  end

  def current_cas_name=(cas_name)
    session[:temp_cas_user] = cas_name
  end

  def current_cas_name
    if ENV['CAS-TEST-MODE']
      session[:temp_cas_user] || session[:userinfo].split("@")[0]
    else
      session[:userinfo].split("@")[0]
    end
  end
end