class UserMailer < ActionMailer::Base

  def registration_confirmation(user)
    @user = user
    @my_tw_url = 'https://my.thoughtworks.com/groups/jc-review-site'
    mail(:to => "<#{user.email}>", :subject => "[ReviewSite] You were registered!")
  end

  def password_reset(user)
    @user = user
    @my_tw_url = 'https://my.thoughtworks.com/groups/jc-review-site'
    mail(:to => "<#{user.email}>", :subject => "[ReviewSite] Recover your account")
  end

  def review_creation(review)
    @review = review
    @jc_name = review.junior_consultant.user.name
    @jc_email = review.junior_consultant.user.email
    @review_type = review.review_type
    @review_date = review.review_date
    @feedback_deadline = review.feedback_deadline
    @my_tw_url = 'https://my.thoughtworks.com/groups/jc-review-site'
    mail(:to => "<#{@jc_email}>", :subject => "[ReviewSite] Your #{@review_type} review has been created")
  end

  def new_feedback_notification(feedback)
    @feedback = feedback
    @review = feedback.review
    @reviewer = feedback.user
    @reviewee = @review.junior_consultant
    @my_tw_url = 'https://my.thoughtworks.com/groups/jc-review-site'
    mail(:to => "<#{@reviewee.user.email}>", :subject => "[ReviewSite] You have new feedback from #{@reviewer}")
  end

  def review_invitation(review, email, message)
    jc = review.junior_consultant
    @custom_message = message
    mail(:to => "<#{email}>", :subject => "[ReviewSite] You've been invited to give feedback for #{jc.user.name}")
  end

  def feedback_reminder(invitation)
    @jc = invitation.reviewee
    @review = invitation.review
    @feedback = invitation.feedback
    @my_tw_url = 'https://my.thoughtworks.com/groups/jc-review-site'
    mail(:to => "<#{invitation.email}>", :subject => "[ReviewSite] Please leave feedback for #{@jc.user.name}")
  end
end
