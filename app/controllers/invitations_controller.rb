class InvitationsController < ApplicationController
  load_resource :review
  load_and_authorize_resource :through => :review
  before_filter :load_review, :only => [:new, :create]
  before_filter :load_invitation, :only => [:destroy, :send_reminder]

  def new
    @ac = @review.associate_consultant
  end

  def create
    @invitation = @review.invitations.build(username: params[:username])

    if not @invitation.feedback and @invitation.save
      if params[:no_email]
        flash[:notice] = "An invitation has been created!"
      else
        UserMailer.review_invitation(@review, "#{params[:username]}@thoughtworks.com", params[:message]).deliver
        flash[:notice] = "An invitation has been sent!"
      end
      redirect_to root_path
    else
      if @invitation.feedback
        flash[:notice] = "This person has already created feedback for this review."
      end
      @ac = @review.associate_consultant
      render "new"
    end
  end

  def destroy
    @invitation.destroy
    redirect_to root_path, notice: 'Invitation has been deleted'
  end

  def send_reminder
    if @invitation.feedback and @invitation.feedback.submitted?
      flash[:notice] = "Feedback already submitted. Reminder not sent."
    else
      UserMailer.feedback_reminder(@invitation).deliver
      flash[:notice] = "Reminder email was sent!"
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
