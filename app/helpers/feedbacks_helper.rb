module FeedbacksHelper

  def feedback_priorities
    [ ["1st", 1], ["2nd", 2], ["3rd", 3], ["4th", 4] ]
  end

  #TODO: write tests
  def open_requests(user)
    invitations = Invitation.where(email: user.all_emails)

    user.feedbacks.where(submitted: false).count + invitations.count
  end

end
