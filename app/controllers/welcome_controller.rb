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

    @feedbacks = []
    Feedback.all.each do |feedback|
      if can? :edit, feedback or can? :read, feedback or can? :submit, feedback
        @feedbacks << feedback
      end
    end
    @feedbacks = @feedbacks.sort{|a,b| b.updated_at <=> a.updated_at}

    @invitations = []
    Invitation.all.each do |invitation|
      if invitation.sent_to?(current_user) and not invitation.expired?
        @invitations << invitation
      end
    end
  end

  def help
  end
end
