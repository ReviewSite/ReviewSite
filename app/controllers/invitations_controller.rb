class InvitationsController < ApplicationController
  skip_authorization_check

  def new
    @review = Review.find_by_id(params[:review_id])
  end

  def create
    redirect_to root_path, notice: 'An invitation has been sent!'
  end
end