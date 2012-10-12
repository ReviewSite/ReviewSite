class WelcomeController < ApplicationController
  skip_authorization_check

  def index
    @reviews = []
    Review.all.each do |review|
      if can? :read, review
        @reviews << review
      end
    end
    @reviews = @reviews.sort{|a,b| a.review_date.nil? ? 1 : b.review_date.nil? ? -1 : a.review_date <=> b.review_date }

    @feedbacks = []
    Feedback.all.each do |feedback|
      if can? :read, feedback
        @feedbacks << feedback
      end
    end
    @feedbacks = @feedbacks.sort{|a,b| b.updated_at <=> a.updated_at}
  end

  def help
  end
end
