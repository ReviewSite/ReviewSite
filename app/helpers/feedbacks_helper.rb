module FeedbacksHelper
  def feedback_priorities
    [ ["1st", 1], ["2nd", 2], ["3rd", 3], ["4th", 4] ]
  end

  def open_requests(user)
    invitations = Invitation.eager_load(:feedbacks).where(email: user.all_emails).select {|i| i.feedbacks.compact.empty? }
    user.feedbacks.unsubmitted.size + invitations.size
  end
end
