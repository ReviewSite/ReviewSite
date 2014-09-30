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
      flash[:success] = "User has been successfully created"
      if @user.ac? && !@user.associate_consultant.program_start_date.nil?
        self.create_reviews
        flash[:success] += " with 6-Month, 12-Month, 18-Month, and 24-Month reviews"
      end
      flash[:success] += "."
      UserMailer.registration_confirmation(@user).deliver

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
      selected = "1"
      if params[:isac] == selected && !@user.associate_consultant.program_start_date.nil?
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
    reviews = Review.create_default_reviews(@user.associate_consultant)
    UserMailer.reviews_creation(reviews[0]).deliver
  end

  private
  def load_user
    @user = User.find(params[:id])
  end
end
