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

    UserMailer.review_invitation(params).deliver
    redirect_to root_path, notice: 'An invitation has been sent!'
  end
end