class InvitationsController < ApplicationController
  load_resource :review
  load_and_authorize_resource :through => :review

  def new
    @review = Review.find_by_id(params[:review_id])
    @jc = @review.junior_consultant
  end

  def create
    @review = Review.find_by_id(params[:review_id])
    @invitation = @review.invitations.build(email: params[:email])

    if not @invitation.feedback and @invitation.save
      if params[:no_email]
        flash[:notice] = "An invitation has been created!"
      else
        UserMailer.review_invitation(@review, params[:email], params[:message]).deliver
        flash[:notice] = "An invitation has been sent!"
      end
      redirect_to root_path
    else
      if @invitation.feedback
        flash[:notice] = "This person has already created feedback for this review."
      end
      @jc = @review.junior_consultant
      render "new"
    end
  end

  def destroy
    Invitation.find_by_id(params[:id]).destroy
    redirect_to root_path, notice: 'Invitation has been deleted'
  end

  def send_reminder
    invitation = Invitation.find_by_id(params[:id])
    if invitation.feedback and invitation.feedback.submitted?
      flash[:notice] = "Feedback already submitted. Reminder not sent."
    else
      UserMailer.feedback_reminder(invitation).deliver
      flash[:notice] = "Reminder email was sent!"
    end
    redirect_to root_path
  end
end
