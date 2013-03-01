class PasswordResetsController < ApplicationController
  skip_authorization_check only: [:new, :create]

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    UserMailer.password_reset(user)
    redirect_to root_url, notice: "Password reset email has been sent."
  end
end
