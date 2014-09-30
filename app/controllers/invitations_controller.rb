class InvitationsController < ApplicationController
  load_resource :review
  load_and_authorize_resource :through => :review
  before_filter :load_review, :only => [:new, :create]
  before_filter :load_invitation, :only => [:destroy, :send_reminder]

  def new
    @ac = @review.associate_consultant
  end

  def create
    flash.clear
    errors = []
    successes = []
    for email in params[:emails].split(",").map{ |email| email.strip.downcase } do
      @invitation = @review.invitations.build(email: email)
      if not @invitation.feedback and @invitation.save and email.include? "thoughtworks.com"
        if params[:no_email]
          flash[:success] = "An invitation has been created!"
        else
          UserMailer.review_invitation(@review, "#{email}", params[:message]).deliver
          flash[:success] = "An invitation has been sent!"
        end
        successes << email
      else
        if @invitation.feedback
          errors << "#{email} has already created feedback for this review."
        elsif !@invitation.errors.messages[:email].nil? \
          and @invitation.errors.messages[:email].include? "is invalid"
          errors << "#{email} could not be invited -- Invalid Email."
        elsif !@invitation.errors.messages[:email].nil? \
          and @invitation.errors.messages[:email].include? "has already been taken"
          errors << "#{email} could not be invited -- Email already invited."
        elsif !email.include? "thoughtworks.com"
          errors << "#{email} could not be invited -- Not a ThoughtWorks Email."
        end
      end
    end

    success_message = nil
    unless successes.empty?
      success_message = "An invitation has been "
      if(params[:no_email])
        success_message += "created for: "
      else
        success_message += "sent to: "
      end
      success_message += successes.join(", ")
    end

    if errors.empty?
      if success_message
        flash[:success] = success_message
      end
      redirect_to root_path
    else
      if success_message
        flash.now[:success] = success_message
      end
      flash.now[:alert] = ""
      for error in errors do
        flash.now[:alert] += error + "\n"
      end
      @ac = @review.associate_consultant
      render 'new'
    end
  end



  def destroy
    @invitation.destroy
    redirect_to root_path, notice: 'Invitation has been deleted'
  end

  def send_reminder
    if @invitation.feedback and @invitation.feedback.submitted?
      flash[:alert] = "Feedback already submitted. Reminder not sent."
    else
      UserMailer.feedback_reminder(@invitation).deliver
      flash[:success] = "Reminder email was sent!"
    end
    redirect_to root_path
  end

  private
  def load_review
    @review = Review.find_by_id(params[:review_id])
  end

  def load_invitation
    @invitation = Invitation.find_by_id(params[:id])
  end
end
