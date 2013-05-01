class UsersController < ApplicationController
  load_and_authorize_resource
  skip_before_filter :login_from_cas, only: [:new, :create]

  def new
    @user = User.new
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      if signed_in?
        UserMailer.admin_registration_confirmation(@user).deliver
        flash[:success] = "User has been successfully created."
        redirect_to root_path
      else
        UserMailer.self_registration_confirmation(@user).deliver
        flash[:success] = "User has been successfully created."
        redirect_to signin_path
      end
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in_to_stay_logged_in_as_current_user
      redirect_to root_url
    else
      render 'edit'
    end
  end


  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def feedbacks
    @user = User.find(params[:id])
    @feedbacks = @user.feedbacks
  end

  private

    def sign_in_to_stay_logged_in_as_current_user
      if current_user?(@user)
        sign_in @user
      end
    end
end
