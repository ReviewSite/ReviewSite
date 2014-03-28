class SessionsController < ApplicationController
  skip_before_filter :require_login, only: [:callback]
  skip_authorization_check
  
  def new
    if signed_in?
      redirect_to root_url
    end
  end

  def callback
    session[:userinfo] = request.env['omniauth.auth'].uid
    redirect_back_or(root_url)
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      first_time_sign_in user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
  end

  def set_temp_cas
    self.current_cas_name = params["temp-cas"]
    redirect_to root_url
  end
end
