class AdminController < ApplicationController
  skip_authorization_check

  def index
    @reviews = Review.all
    @feedbacks = Feedback.all
    render nothing: true
  end
end
