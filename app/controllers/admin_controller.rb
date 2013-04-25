class AdminController < ApplicationController
  skip_authorization_check

  def index
    unless current_user.admin?
      redirect_to root_url 
    else
      @reviews = Review.all
      @feedbacks = Feedback.all
      render nothing: true
    end
  end
end
