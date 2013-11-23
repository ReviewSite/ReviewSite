class FeedbacksController < ApplicationController
  load_and_authorize_resource
  before_filter :load_review

  def load_review
    @review = Review.find(params[:review_id])
  end

  # GET /feedbacks/1
  # GET /feedbacks/1.json
  def show
    @feedback = Feedback.find(params[:id])

    respond_to do |format|
      # format.html # show.html.erb

      if @review.new_review_format
        format.html { render "show_four_questions" }
      else
        format.html { render "show" }
      end

      format.json { render json: @feedback }
    end
  end

  # GET /feedbacks/additional
  def additional
    @feedback = Feedback.new

    respond_to do |format|
      format.html # additional.html.erb
      format.json { render json: @feedback }
    end
  end

  # GET /feedbacks/new
  # GET /feedbacks/new.json
  def new
    @feedback = Feedback.new
    @review.feedbacks.each do |f|
      if f.user == current_user and f.user_string.nil?
        @feedback = f
        break
      end
    end
    @user_name = current_user.name

    respond_to do |format|
      format.html do
        if @feedback.submitted?
          redirect_to root_path, notice: "You have already submitted feedback."
        else
          render html: @feedback
          # if @review.new_review_format 
          #   format.html { render "_form_new_view" }
          # else
          #   format.html { render "_form_old_view" }
          # end
        end
      end
      format.json { render json: @feedback }
    end
  end

  # GET /feedbacks/1/edit
  def edit
    @feedback = Feedback.find(params[:id])
    @user_name = current_user.name
  end

  # POST /feedbacks
  # POST /feedbacks.json
  def create
    @feedback = Feedback.new(params[:feedback])
    @feedback.review = @review
    @feedback.user = current_user

    respond_to do |format|
      if @feedback.save
        if params[:submit_final_button] 
          @feedback.submit_final
          format.html { redirect_to [@review, @feedback], notice: 'Feedback was submitted.' }
        else
          format.html do
            redirect_to edit_review_feedback_path(@review.id, @feedback.id)
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
    @feedback = Feedback.find(params[:id])

    respond_to do |format|
      if @feedback.update_attributes(params[:feedback])
        if params[:submit_final_button] 
          @feedback.submit_final
          format.html { redirect_to [@review, @feedback], notice: 'Feedback was submitted.' }
        elsif params[:delete_feedback_button]
          @feedback.destroy
          format.html { redirect_to root_path, notice: 'Feedback was successfully deleted.' }
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
    @feedback = Feedback.find(params[:id])

    respond_to do |format|
      if @feedback.save
        @feedback.submit_final
        format.html { redirect_to root_path, notice: 'Feedback was successfully updated.' }
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
    @feedback = Feedback.find(params[:id])
    @feedback.submitted = false

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to root_path, notice: 'Feedback was successfully updated.' }
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
    Feedback.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

  def send_reminder
    feedback = Feedback.find_by_id(params[:id])
    if feedback.submitted?
      flash[:notice] = "Feedback already submitted. Reminder not sent."
    else
      if feedback.invitation
        invitation = feedback.invitation
      else
        review = feedback.review
        invitation = review.invitations.build(:email => feedback.user.email)
      end
      UserMailer.feedback_reminder(invitation).deliver
      flash[:notice] = "Reminder email was sent!"
    end
    redirect_to root_path
  end
end
