class InvitationsController < ApplicationController
  load_resource :review
  load_and_authorize_resource :through => :review
  before_filter :load_review, :only => [:new, :create]
  before_filter :load_invitation, :only => [:destroy, :send_reminder]

  def new
    @ac = @review.associate_consultant
  end

  def create
    errors = []
    successes = []
    for email in params[:emails].split(",").map{ |email| email.strip } do
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
        elsif !@invitation.errors.messages[:email].nil? and @invitation.errors.messages[:email].include? "is invalid"
          errors << "#{email} could not be invited -- Invalid Email."
        elsif !email.include? "thoughtworks.com"
          errors << "#{email} could not be invited -- Not a ThoughtWorks Email."
        end
      end
    end

    unless successes.empty?
      flash[:success] = "An invitation has been "
      if(params[:no_email])
        flash[:success] += "created for: "
      else
        flash[:success] += "sent to: "
      end
      flash[:success] += successes.join(", ")
    end

    if errors.empty?
      redirect_to root_path
    else
      flash[:alert] = ""
      for error in errors do
        flash[:alert] += error
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
