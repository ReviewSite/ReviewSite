class SessionsController < ApplicationController
  skip_authorization_check
  def new
  end
  
  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or(root_url)
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
  end

  def set_temp_cas
    local_sign_out
    self.current_cas_user = params["temp-cas"]
    redirect_to root_url
  end
end
