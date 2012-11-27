class WelcomeController < ApplicationController
  skip_authorization_check

  def index
    @reviews = Review.readable_and_sumarizeable_for_user(current_user)

    @feedbacks = Feedback.editable_and_submitable_for_user(current_user)
  end

  def help
  end
end
