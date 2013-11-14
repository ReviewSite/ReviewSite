class SessionsController < ApplicationController
  skip_authorization_check
  
  def new
    if signed_in?
      redirect_to root_url
    end
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
