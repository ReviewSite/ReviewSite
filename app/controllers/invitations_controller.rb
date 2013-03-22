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

    if @invitation.save
      UserMailer.review_invitation(@review, params[:email], params[:message]).deliver
      redirect_to root_path, notice: 'An invitation has been sent!'
    else
      @jc = @review.junior_consultant
      render "new"
    end
  end

  def destroy
    Invitation.find_by_id(params[:id]).destroy
    redirect_to root_path, notice: 'Invitation has been deleted'
  end
end
