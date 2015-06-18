module SessionsHelper

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end

  def signed_in?(options ={})
    not current_user.nil?
  end

  def current_user
    @current_user || reset_current_user
  end

  def reset_current_user
    @current_user = User.find_by_okta_name( current_okta_name )
  end

  def current_okta_name=(okta_name)
    session[:temp_okta_user] = okta_name
  end

  def current_okta_name
    if ENV["OKTA-TEST-MODE"]
      session[:temp_okta_user] || session[:userinfo].split("@")[0]
    else
      session[:userinfo].split("@")[0]
    end
  end

  def current_name
    if ENV["OKTA-TEST-MODE"]
      session[:temp_okta_user] || session[:userinfo].split("@")[0]
    else
      session[:user_name] || session[:userinfo].split("@")[0]
    end
  end

  def current_email
    session[:userinfo].downcase
  end
end
