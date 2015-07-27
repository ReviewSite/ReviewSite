module FeedbacksHelper
  def feedback_priorities
    [ ["1st", 1], ["2nd", 2], ["3rd", 3], ["4th", 4] ]
  end

  def open_requests(user)
    invitations = Invitation.where(email: user.all_emails).select do |invitation|
      invitation.feedbacks.where(user_id: user).compact.empty?
    end
    get_peer_reported_feedback(user.feedbacks).size + invitations.size
  end

  def get_peer_reported_feedback(feedbacks)
    peer_reported_feedback = []
    feedbacks.unsubmitted.each do |feedback|
      if !feedback.is_additional
        peer_reported_feedback.push(feedback)
      end
    end
    return peer_reported_feedback
  end

end
