module FeedbacksHelper

  def feedback_priorities
    [ ["1st", 1], ["2nd", 2], ["3rd", 3], ["4th", 4] ]
  end

  #TODO: write tests
  def open_requests(user)

    invitations = []
    Invitation.includes(:review).each do |invitation|
      if invitation.sent_to?(current_user) and !invitation.feedback
        invitations << invitation
      end
      if extra_email = AdditionalEmail.find_by_email(invitation.email)
        if User.find(extra_email.user_id) == current_user
          invitations << invitation
        end
      end
    end

    user.feedbacks.where("submitted = ?", false).count + invitations.count
  end

end
