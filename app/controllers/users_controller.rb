class UsersController < ApplicationController
  load_and_authorize_resource
  before_filter :load_user, :only => [:show, :edit, :update, :destroy, :feedbacks]

  def new
    @user = User.new
  end

  def index
    @users = User.all
  end

  def show; end

  def edit; end

  def create
    @user = User.new(params[:user])
    if @user.save
      UserMailer.registration_confirmation(@user).deliver
      flash[:success] = "User has been successfully created."
      redirect_to users_url
    else
      render 'new'
    end
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      redirect_to users_url
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def feedbacks
    @feedbacks = @user.feedbacks
  end

  def autocomplete_coach_name
    coach_names = User.select([:name]).where("name ILIKE ?", "%#{params[:name]}%")
    @result = coach_names.collect { |coach| {value: coach.name} }
    render json: @result
  end

  private
  def load_user
    @user = User.find(params[:id])
  end
end
