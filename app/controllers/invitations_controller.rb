class InvitationsController < ApplicationController
  load_resource :review
  load_and_authorize_resource :through => :review
  before_filter :load_review, :only => [:new, :create]
  before_filter :load_invitation, :only => [:destroy, :send_reminder]

  def new
    @ac = @review.associate_consultant
  end

  def create
    emails = params[:emails].split(/[,;]/).map { |email| email.strip.downcase }
    builder = InvitationMessageBuilder.new(params[:no_email])
    copy_sender = (params[:copy_sender] == '1')
    builder.check_for_emails(emails)

    emails.map do |email|
      @invitation = @review.invitations.build(email: email)
      if @invitation.save && !params[:no_email]
        UserMailer.review_invitation(@review, "#{email}", params[:message], params[:subject]).deliver
      end
      builder.with(@invitation).build(email)
    end

    if copy_sender && builder.successes.any?
      UserMailer.review_invitation_AC_copy(@review, params[:message], builder.successes).deliver
    end

    if builder.errors.any?
      flash.now[:success] = builder.success_message if builder.successes.any?
      flash.now[:alert] = builder.error_message
      @ac = @review.associate_consultant
      @new_subject = params[:subject]
      @new_message = params[:message]
      render 'new'
    else
      flash[:success] = builder.success_message if builder.successes.any?
      redirect_to @review
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
    redirect_to :back
  end

  def send_reminder
    if !@invitation.feedback
      UserMailer.reminder_for_invitation(@invitation).deliver
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
