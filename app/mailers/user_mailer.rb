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
    @ac_name = review.associate_consultant.user.name
    @ac_email = review.associate_consultant.user.email
    @review_type = review.review_type
    @review_date = review.review_date
    @feedback_deadline = review.feedback_deadline
    @my_tw_url = 'https://my.thoughtworks.com/groups/jc-review-site'
    mail(:to => "<#{@ac_email}>", :subject => "[ReviewSite] Your #{@review_type} review has been created")
  end

  def reviews_creation(next_review)
    @next_review = next_review
    @ac_name = next_review.associate_consultant.user.name
    @ac_email = next_review.associate_consultant.user.email
    @my_tw_url = 'https://my.thoughtworks.com/groups/jc-review-site'
    mail(:to => "<#{@ac_email}>", :subject => "[ReviewSite] Reviews have been created for you")
  end

  def new_feedback_notification(feedback)
    @feedback = feedback
    @review = feedback.review
    @reviewer = feedback.user
    @reviewee = @review.associate_consultant
    @my_tw_url = 'https://my.thoughtworks.com/groups/jc-review-site'
    mail(:to => "<#{@reviewee.user.email}>", :subject => "[ReviewSite] You have new feedback from #{@reviewer}")
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
    @my_tw_url = 'https://my.thoughtworks.com/groups/jc-review-site'
    mail(:to => "<#{invitation.email}>", :subject => "[ReviewSite] Please leave feedback for #{@ac.user.name}")
  end
end
