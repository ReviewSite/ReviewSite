class UsersController < ApplicationController
  load_and_authorize_resource
  before_filter :load_user, :only => [:show, :edit, :update, :destroy, :feedbacks]

  def new
    @user = User.new
    @user.build_associate_consultant
  end

  def index
    respond_to do |format|
      format.html
      format.json { render json: UsersDatatable.new(view_context, current_ability) }
    end
  end

  def show; end

  def edit
    if @user.associate_consultant.nil?
      @user.build_associate_consultant
    end
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      if @user.ac? && !@user.start_date.nil?
        self.create_reviews
      end
      UserMailer.registration_confirmation(@user).deliver
      flash[:success] = "User has been successfully created"
      if @user.ac?
        flash[:success] += " with 6-Month, 12-Month, 18-Month, and 24-Month reviews"
      end
      flash[:success] += "."

      if current_user && current_user.admin?
        redirect_to users_path
      else
        redirect_to root_path
      end

    else
      render 'new'
    end
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      if params[:isac].to_s=="1" && !@user.start_date.nil?
        self.create_reviews
        flash[:success] += " and reviews created"
      end

      if current_user.admin?
        redirect_to users_path
      else
        redirect_to root_path
#        redirect_to user_path(@user)
      end

    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  def feedbacks
    @invitations = Invitation.select{|invitation| invitation.sent_to?(current_user) && !invitation.feedback}
    @feedbacks = current_user.feedbacks.where(submitted: false)
    @completeds = current_user.feedbacks.where(submitted: true)
  end

  def get_users
    @users = User.where("name ILIKE ?", "%#{params[:q]}%")

    respond_to do |format|
      format.html
      format.json { render :json => @users.map{ |user| {:id => user.id, :name => user.name} } }
    end
  end

  def create_reviews
    (6..24).step(6) do |n|
      Review.create({associate_consultant_id: @user.associate_consultant.id,
      review_type: n.to_s + "-Month",
      review_date: @user.start_date + n.months,
      feedback_deadline: @user.start_date + n.months - 2.days})
    end
  end

  private
  def load_user
    @user = User.find(params[:id])
  end
end
