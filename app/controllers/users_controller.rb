class UsersController < ApplicationController
  skip_authorization_check :only => [:new, :create]
  load_and_authorize_resource :except => [:new, :create]

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
      signed_in? ? UserMailer.admin_registration_confirmation(@user).deliver : UserMailer.self_registration_confirmation(@user).deliver
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
      relogin_as_self_after_logout
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

    def relogin_as_self_after_logout
      if @user == current_user 
        sign_in @user
      end
    end
end
