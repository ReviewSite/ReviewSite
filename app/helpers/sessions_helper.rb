module SessionsHelper
  def first_time_sign_in(user)
    user.update_attribute(:okta_name, current_okta_name)
    flash[:notice] = "From now on, we will sign you in automatically via OKTA."
    redirect_back_or(root_url)
  end

  def signed_in?
    not current_user.nil?
  end

  def current_user
    @current_user || reset_current_user
  end

  def reset_current_user
    @current_user = User.find_by_okta_name( current_okta_name )
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
    redirect_to "https://thoughtworks.okta.com/login/signout?fromURI=#{ENV['URL']}"
  end

  def current_okta_name=(okta_name)
    session[:temp_okta_user] = okta_name
  end

  def current_okta_name
    if ENV['OKTA-TEST-MODE']
      # "noob"
     # "admin"
      session[:temp_okta_user] || session[:userinfo].split("@")[0]
    else
      session[:userinfo].split("@")[0]
    end
  end
end
