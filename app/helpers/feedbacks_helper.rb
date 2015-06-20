module FeedbacksHelper
  def feedback_priorities
    [ ["1st", 1], ["2nd", 2], ["3rd", 3], ["4th", 4] ]
  end

  def open_requests(user)
    invitations = Invitation.where(email: user.all_emails).select do |invitation|
      invitation.feedbacks.where(user_id: user).compact.empty?
    end

    user.feedbacks.unsubmitted.size + invitations.size
  end
end
