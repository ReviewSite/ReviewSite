class WelcomeController < ApplicationController
  skip_authorization_check

  def index
    @reviews = []
    Review.all.each do |review|
      if can? :read, review or can? :summary, review
        @reviews << review
      end
    end
    @reviews = @reviews.sort{|a,b| a.review_date.nil? ? 1 : b.review_date.nil? ? -1 : a.review_date <=> b.review_date }

    @feedbacks = Feedback.all.sort{ |a,b| b.updated_at <=> a.updated_at }
    @feedbacks_in_progress = []
    @feedbacks.each do |feedback|
      @feedbacks_in_progress << feedback if can? :edit?, feedback
    end

    @invitations_received = []
    Invitation.all.each do |invitation|
      if signed_in? and invitation.sent_to?(current_user) and invitation.feedback.nil?
        @invitations_received << invitation
      end
    end
  end

  def help
  end

  def test_error
    raise NotImplementedError, "This controller action breaks on purpose."
  end
end
