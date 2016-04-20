class FeedbacksController < ApplicationController
  load_resource :review
  load_and_authorize_resource through: :review
  before_filter :load_review
  before_filter :load_feedback, :only => [:show, :edit, :edit_additional, :update, :submit, :unsubmit, :send_reminder]
  before_filter :load_user_name, :only => [:new, :new_additional, :edit, :edit_additional]

  # GET /feedbacks/1
  # GET /feedbacks/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feedback }
    end
  end

  def preview
    respond_to do |format|
      format.html
      format.json { render json: @feedback }
    end
  end

  # GET /feedbacks/new
  # GET /feedbacks/new.json
  def new
    find_feedback_for(current_user) if @review.has_existing_feedbacks?
    respond_to do |format|
      format.html { redirect_to root_path, notice: "You have already submitted feedback." if @feedback.submitted? }
      format.json { render json: @feedback }
    end
  end

  # GET /feedbacks/new_additional
  # GET /feedbacks/new_additional.json
  def new_additional
    @feedback = Feedback.new
    respond_to do |format|
      format.html
      format.json { render json: @feedback }
    end
  end

  # GET /feedbacks/1/edit
  def edit
    respond_to do |format|
      format.html
      format.json { render json: @feedback }
    end
  end

  # GET /feedbacks/1/edit_additional
  def edit_additional
    respond_to do |format|
      format.html
      format.json { render json: @feedback }
    end
  end

  # POST /feedbacks
  # POST /feedbacks.json
  def create
    @feedback = @review.feedbacks.build(params[:feedback])
    @feedback.user = current_user
    respond_to do |format|
      if @feedback.save
        format.html { execute_button_action(format) }
        format.json { render json: [@review, @feedback], status: :created, location: [@review, @feedback] }
      else
        if params[:feedback][:user_string].nil?
          format.html { render action: "new" }
        else
          format.html { render action: "new_additional" }
        end
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /feedbacks/1
  # PUT /feedbacks/1.json
  def update
    respond_to do |format|
      if @feedback.update_attributes(params[:feedback])
        format.html { execute_button_action(format) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feedbacks/1
  # DELETE /feedbacks/1.json
  def destroy
    @feedback.destroy
    flash[:success] = "You have successfully deleted your feedback for #{@review.reviewee}."
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

  def send_reminder
    if @feedback.submitted?
      flash[:alert] = "Feedback already submitted. Reminder not sent."
    else
      if @feedback.invitation
        invitation = @feedback.invitation
      else
        review = @feedback.review
        invitation = review.invitations.build(:email => @feedback.user.email)
      end
      UserMailer.feedback_reminder(invitation).deliver
      flash[:success] = "Reminder email was sent!"
    end
    redirect_to root_path
  end

  private
  def load_feedback
    @feedback = Feedback.find_by_id(params[:id])
  end

  def load_user_name
    @user_name = current_user.name
  end

  def load_review
    @review = Review.find(params[:review_id])
  end

  def find_feedback_for(user)
    @review.feedbacks.includes(:user).each do |f|
      if f.user == current_user and f.user_string.nil?
        @feedback = f
        break
      end
    end
  end

  def execute_button_action(format)
    if params[:submit_final_button]
      execute_submit_final_action()
    elsif params[:preview_and_submit_button]
      redirect_to preview_review_feedback_path(@review, @feedback)
    else
      execute_save_or_edit_action()
    end
  end

  def execute_submit_final_action
    @feedback.submit_final
    flash[:success] = 'Feedback was submitted.'
    if @feedback.is_additional
      redirect_to summary_review_path(@review)
    else
      redirect_to completed_feedback_user_path(current_user)
    end
  end

  def execute_save_or_edit_action
    if @feedback.is_additional
      redirect_to edit_additional_review_feedback_path(@review, @feedback)
    else
      redirect_to edit_review_feedback_path(@review, @feedback)
    end
    flash[:success] = 'Feedback was saved for further editing.'
  end

end
