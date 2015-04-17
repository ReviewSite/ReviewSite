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
      if @invitation.save and email.include? "thoughtworks.com"
        if params[:no_email]
          flash[:success] = "An invitation has been created!"
        else
          UserMailer.review_invitation(@review, "#{email}", params[:message]).deliver
          flash[:success] = "An invitation has been sent!"
        end
        successes << email
      else
        if @invitation.errors.messages.any?
          for error in @invitation.errors.messages.values.flatten
            errors << error
          end
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
      redirect_to @review
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
    invitation_email = @invitation.email
    @invitation.delete_invite
    if (current_user.email == invitation_email)
      UserMailer.feedback_declined(@invitation).deliver
      flash[:success] = "You have successfully declined #{@review.reviewee.name}'s feedback request."
    else
      flash[:success] = "#{invitation_email}\'s invitation has been deleted."
    end

    redirect_to root_path
  end

  def send_reminder
    if @invitation.feedback and @invitation.feedback.submitted?
      flash[:alert] = "Feedback already submitted. Reminder not sent."
    else
      UserMailer.feedback_reminder(@invitation).deliver
      flash[:success] = "Reminder email was sent!"
    end
    redirect_to @review
  end

  private
  def load_review
    @review = Review.find_by_id(params[:review_id])
  end

  def load_invitation
    @invitation = Invitation.find_by_id(params[:id])
  end
end
