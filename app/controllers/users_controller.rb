class UsersController < ApplicationController
  load_and_authorize_resource
  before_filter :load_user, :only => [:show, :edit, :update, :destroy, :feedbacks]
  respond_to :js

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

  def add_email
    respond_to do |format|
      format.js do
        emails = params[:additional_email]
        if !emails.nil?
          emails = emails.split(',')
          if emails.kind_of?(Array)
            emails.each do |email|
              @new_email = AdditionalEmail.new(user_id: @user.id, email: email)
              if @new_email.save
                # render "additional_emails/add_email.js.erb",
                #   locals: { email: @new_email }
              else
                # render 'edit'
              end
              render "additional_emails/add_email",
                locals: { email: @new_email }
            end
          end
        else
          render 'edit'
        end
        # render "additional_emails/add_email.js.erb",
        #   locals: { email: params[:additional_email] }
      end
    end
  end

  def remove_email
    respond_to do |format|
      format.js do
        email_id = params[:additional_email_id]
        if defined?(email_id)
          AdditionalEmail.destroy(email_id)
        end
      end
      render 'edit'
    end
  end

  def destroy
    flash[:success] = "User \"#{@user.name}\" was successfully deleted."
    @user.destroy
    redirect_to users_url
  end

  def feedbacks
    @invitations = Invitation.includes(:review, {:review => {:associate_consultant => :user}}).select do |invitation|
      if invitation.sent_to?(current_user) && !invitation.feedback
        next(true)
      elsif extra_email = AdditionalEmail.find_by_email(invitation.email)
        if extra_email.confirmed_at?
          next(User.find(extra_email.user_id) == current_user)
        end
      end
    end

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
