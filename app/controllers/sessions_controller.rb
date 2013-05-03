class SessionsController < ApplicationController
  skip_authorization_check
  skip_before_filter :login_from_cas
  
  def new
  end
  
  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      user.update_attribute(:cas_name, current_cas_name)
      sign_in user
      flash[:notice] = "From now on, we will sign you in automatically via CAS."
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
    self.current_cas_name = params["temp-cas"]
    redirect_to root_url
  end
end
