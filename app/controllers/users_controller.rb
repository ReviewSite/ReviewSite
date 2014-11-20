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
      flash[:success] = "User \"#{@user.name}\" was successfully created"
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
      if @user.associate_consultant.nil?
        @user.build_associate_consultant
      end
      render 'new'
    end
  end

  def update
    emails = params[:additional_emails]
    if !emails.nil? && emails.kind_of?(Array)
      emails = emails.split(',')
      emails.each do |email|
        new_email = AdditionalEmail.create(user_id: @user.id, email: email)
        puts "NEW EMAIL: #{new_email}"
      end
    end
    if @user.update_attributes(params[:user])
      flash[:success] = "User \"#{@user.name}\" was successfully updated"
      selected = "1"
      if params[:isac] == selected && !@user.associate_consultant.program_start_date.nil?
        self.create_reviews
        flash[:success] += " and reviews created"
      end
      flash[:success] += "."

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
    flash[:success] = "User \"#{@user.name}\" was successfully deleted."
    @user.destroy
    redirect_to users_url
  end

  def feedbacks
    @invitations = Invitation.includes(:review, {:review => {:associate_consultant => :user}}).select{|invitation| invitation.sent_to?(current_user) && !invitation.feedback}

    @feedbacks = current_user.feedbacks.includes(:review).where(submitted: false)
  end

  def completed_feedback
    @completeds = current_user.feedbacks.includes(:review, {:review => :associate_consultant}).where(submitted: true)
  end

  def get_users
    @users = User.where("name ILIKE ?", "%#{params[:q]}%")

    unless request.xhr?
      redirect_to root_path
      flash[:alert] = "You are not authorized to view this page."
      return
    end

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
