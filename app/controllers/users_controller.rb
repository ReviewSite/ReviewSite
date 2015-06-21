class UsersController < ApplicationController
  load_and_authorize_resource
  before_filter :load_user, :only => [:show, :edit, :update, :destroy, :feedbacks]
  respond_to :js

  def new
    @user = User.new
    @user.build_associate_consultant
  end

  def index
    @users = User.includes(:associate_consultant,
                           { associate_consultant: :reviewing_group },
                           :additional_emails)

    respond_to do |format|
      format.html
      format.json { render json: @users }
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
        if !emails.blank?
          emails = emails.split(',')
          if emails.kind_of?(Array)
            emails.each do |email|
              @new_email = AdditionalEmail.new(user_id: @user.id, email: email)
              if @new_email.save
                if flash
                  flash.clear
                end
              else
              end
              render "additional_emails/add_email",
                locals: { email: @new_email }
            end
          end
        else
          render :nothing => true, :status => 200, :content_type => 'text/html'
        end
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
    @invitations = Invitation.where(email: current_user.all_emails).includes(
                                      review: :associate_consultant,
                                      review: { associate_consultant: :user }
                                   ).select { |invitation| !invitation.feedback }

    @feedbacks = current_user.feedbacks.includes(:review, review: :reviewee).where(submitted: false)
  end

  def completed_feedback
    @completeds = current_user.feedbacks.includes(:review,
                                                  review: :associate_consultant,
                                                  review: :reviewee
                                                 ).where(submitted: true)
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
