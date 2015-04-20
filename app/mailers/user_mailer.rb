class UserMailer < ActionMailer::Base
  @my_tw_url = 'https://my.thoughtworks.com/groups/review-site-support'

  def self.my_tw_url
    @my_tw_url
  end

  def registration_confirmation(user)
    @user = user
    mail(:to => "<#{user.email}>", :subject => "[ReviewSite] You were registered!")
  end

  def review_creation(review)
    @review = review
    @ac_name = review.reviewee.name
    @ac_email = review.reviewee.email
    @review_type = review.review_type
    @review_date = review.review_date
    @feedback_deadline = review.feedback_deadline
    mail(:to => "<#{@ac_email}>", :subject => "[ReviewSite] Your #{@review_type} review has been created")
  end

  def reviews_creation(next_review)
    @next_review = next_review
    @ac_name = next_review.reviewee.name
    @ac_email = next_review.reviewee.email
    mail(:to => "<#{@ac_email}>", :subject => "[ReviewSite] Reviews have been created for you")
  end

  def new_feedback_notification(feedback)
    @feedback = feedback
    @review = feedback.review
    @reviewer = feedback.user
    @reviewee = @review.associate_consultant
    mail(:to => "<#{@reviewee.user.email}>", :subject => "[ReviewSite] You have new feedback from #{@reviewer}")
  end

  def new_feedback_notification_coach(feedback)
    @feedback = feedback
    @review = feedback.review
    @reviewer = feedback.user
    @reviewee = @review.associate_consultant
    @coach = @reviewee.coach unless @reviewee.coach.nil?
    mail(:to => "<#{@coach.email}>", :subject => "[ReviewSite] Your coachee, #{@reviewee}, has new feedback from #{@reviewer}")
  end

  def review_invitation(review, email, message)
    ac = review.associate_consultant
    @custom_message = message
    mail(:to => "<#{email}>", :subject => "[ReviewSite] You've been invited to give feedback for #{ac.user.name}")
  end

  def feedback_reminder(invitation)
    @ac = invitation.reviewee
    @review = invitation.review
    @feedback = invitation.feedback
    mail(:to => "<#{invitation.email}>", :subject => "[ReviewSite] Please leave feedback for #{@ac.user.name}")
  end

  def feedback_declined(invitation)
    @invitation = invitation
    @review = invitation.review
    mail(
      :to => "<#{invitation.reviewee.user.email}>",
      :subject =>
        "[ReviewSite] #{invitation.email} has declined your feedback request")
  end
end
