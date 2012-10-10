class WelcomeController < ApplicationController
  skip_authorization_check

  def index
    @reviews = []
    Review.all.each do |review|
      if can? :read, review
        @reviews << review
      end
    end
    @feedbacks = []
    Feedback.all.each do |feedback|
      if can? :read, feedback
        @feedbacks << feedback
      end
    end
  end

  def help
  end
end
