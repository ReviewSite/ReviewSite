class UsersController < ApplicationController
  skip_authorization_check :only => [:new, :create]
  load_and_authorize_resource :except => [:new, :create]

  def new
    if not signed_in? or current_user.admin?
      @user = User.new
      render 'new'
    else
      redirect_to root_url, alert: "You are not authorized to access this page."
    end
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
      else
        UserMailer.self_registration_confirmation(@user).deliver
      end
      flash[:success] = "User has been successfully created."
      redirect_to root_url
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

  private

    def sign_in_to_stay_logged_in_as_current_user
      if current_user?(@user)
        sign_in @user
      end
    end
end
