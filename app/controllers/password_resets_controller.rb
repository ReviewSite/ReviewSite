class PasswordResetsController < ApplicationController
  skip_authorization_check

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    user.request_password_reset if user
    redirect_to signin_path, notice: "Password reset email has been sent."
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Password reset has expired."
    else
      @user.update_attribute(:cas_name, current_cas_name)
      flash[:notice] = "From now on, we will sign you in automatically via CAS."
      redirect_back_or(root_url)
    end
  end
end
