class ReviewsController < ApplicationController
  load_and_authorize_resource
  before_filter :load_review, :only => [:show, :edit, :update, :destroy, :send_email, :notify_stakeholders, :send_reminder_to_all]
  # after_filter :notify_stakeholders, :only => [:update]

  def index
    @reviews = Review.default_load.accessible_by(current_ability)

    if current_user.ac?
      @reviews = current_user.associate_consultant.reviews.includes(:associate_consultant)
    end

    respond_to do |format|
      format.html
      format.json { render json: @reviews }
    end
  end

  def coachees
    @reviews = @reviews.default_load
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @review }
    end
  end

  # GET /reviews/new
  # GET /reviews/new.json
  def new
    @review = Review.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @review }
    end
  end

  # GET /reviews/1/edit
  def edit; end

  # POST /reviews
  # POST /reviews.json
  def create
    @review = Review.new(params[:review])
    respond_to do |format|
      if @review.save
        UserMailer.review_creation(@review).deliver

        flash[:success] = "Review was successfully created."
        format.html { redirect_to @review }
        format.json { render json: @review, status: :created, location: @review }
      else
        format.html { render action: "new" }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reviews/1
  # PUT /reviews/1.json
  def update
    respond_to do |format|
      original_date = @review.feedback_deadline.to_s(:short_date)
      if @review.update_attributes(params[:review])
        message = "Review was successfully updated."
        if feedback_deadline_changed?(original_date)
          message = "Review was updated. Your invitees have been notified of the new feedback deadline."
          notify_stakeholders(@review)
        end
        flash[:success] = message

        format.html { redirect_to @review }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

  # GET /feedbacks
  # GET /feedbacks.json
  def summary
    @feedbacks = @review.feedbacks.accessible_by(current_ability).includes(:user)

    respond_to do |format|
      format.html # summary.html.erb
      format.json { render json: @feedbacks }
      format.xlsx
    end
  end

  def send_reminder_to_all
    sent_reviewers_and_emails = []
    @review.feedbacks.each do |feedback|
      if !feedback.submitted? && feedback.reported_by != Feedback::SELF_REPORTED
        UserMailer.reminder_for_feedback(feedback).deliver
        sent_reviewers_and_emails.append feedback.reviewer
      end
    end
    @review.invitations.each do |invitation|
      if !invitation.feedback
        UserMailer.reminder_for_invitation(invitation).deliver
        sent_reviewers_and_emails.append invitation.email
      end
    end
    unless sent_reviewers_and_emails.empty?
      flash[:success] = "A reminder has been sent to these reviewers and emails: \n "+sent_reviewers_and_emails.join(', ')
    end
    redirect_to @review
  end

  def send_email
    UserMailer.review_creation(@review).deliver
    flash[:success] = "An email with the details of the review was sent!"

    render :js => "window.location = '#{review_path}'"
  end

  def feedback_deadline_changed?(original_date)
    !Date.parse(@review.feedback_deadline.to_s).to_s(:short_date).eql?(original_date.to_s)
  end

  private
  def load_review
    @review = Review.find(params[:id], :include => { :feedbacks => :review , :invitations => :review })
  end

  def notify_stakeholders(review)
    EmailJob.perform_async(review)
  end

  class EmailJob
    include SuckerPunch::Job

    def perform(review)
      review.invitations.each do |i|
        UserMailer.review_update(i, review).deliver
      end
    end
  end
end
