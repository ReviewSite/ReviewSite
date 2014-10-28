class FeedbacksController < ApplicationController
  load_and_authorize_resource
  before_filter :load_review
  before_filter :load_feedback, :only => [:show, :edit, :update, :submit, :unsubmit, :send_reminder ]
  before_filter :load_user_name, :only => [:new, :edit]


  # GET /feedbacks/1
  # GET /feedbacks/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feedback }
    end
  end

  # GET /feedbacks/additional
  def additional
    @feedback = Feedback.new
    @feedback.review = @review
    respond_to do |format|
      format.html # additional.html.erb
      format.json { render json: @feedback }
    end
  end

  # GET /feedbacks/new
  # GET /feedbacks/new.json
  def new
    if @review.invitations.where(email: current_user.email).empty?
      redirect_to root_path, notice: "You have not been invited to submit feedback for this review."
      return
    end
    @feedback = Feedback.new
    @feedback.review = @review
    find_feedback_for(current_user) if @review.has_existing_feedbacks?

    respond_to do |format|
      format.html do
        if @feedback.submitted?
          redirect_to root_path, notice: "You have already submitted feedback."
        else
          render html: @feedback
        end
      end
      format.json { render json: @feedback }
    end
  end

  # GET /feedbacks/1/edit
  def edit; end

  # POST /feedbacks
  # POST /feedbacks.json
  def create
    @feedback = @review.feedbacks.build(params[:feedback])
    @feedback.user = current_user

    respond_to do |format|
      if @feedback.save
        if params[:submit_final_button]
          @feedback.submit_final
          format.html {
            flash[:success] = 'Feedback was submitted.'
            redirect_to [@review, @feedback]
          }
        else
          format.html do
            redirect_to edit_review_feedback_path(@review, @feedback)
            flash[:success] = 'Feedback was saved for further editing.'
          end
        end

        format.json { render json: [@review, @feedback], status: :created, location: [@review, @feedback] }
      else
        if params[:feedback][:user_string].nil?
          format.html { render action: "new" }
        else
          format.html { render action: "additional" }
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
        if params[:submit_final_button]
          @feedback.submit_final
          format.html {
            flash[:success] =  'Feedback was submitted.'
            redirect_to [@review, @feedback]
          }
         else
          format.html do
            redirect_to edit_review_feedback_path(@review.id, @feedback.id)
            flash[:success] = 'Feedback was saved for further editing.'
          end
        end

        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /feedbacks/1/submit
  # PUT /feedbacks/1.json
  def submit
    respond_to do |format|
      if @feedback.save
        @feedback.submit_final
        format.html {
          flash[:success] = 'Feedback was successfully updated.'
          redirect_to root_path
        }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /feedbacks/1/unsubmit
  # PUT /feedbacks/1.json
  def unsubmit
    @feedback.submitted = false
    respond_to do |format|
      if @feedback.save
        format.html {
          flash[:success] = 'Feedback was successfully updated.'
          redirect_to root_path
        }
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
end
