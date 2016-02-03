require 'spec_helper'

describe UserMailer do
  let(:user) { create(:user) }
  let(:ac) { create(:associate_consultant) }
  let(:review) { create(:review, associate_consultant: ac) }
  let(:email) { "recipient@example.com" }
  let(:donotreply) { "do-not-reply@thoughtworks.org" }
  let(:message) { "Hello. Please leave feedback." }
  let(:feedback) { create(:submitted_feedback, user: user, review: review) }

  describe 'Registration confirmation' do
    let(:mail) { UserMailer.registration_confirmation(user) }

    it 'renders the subject' do
      mail.subject.should == '[ReviewSite] You were registered!'
    end

    it 'renders the receiver email' do
      mail.to.should == [user.email]
    end

    it 'renders the sender email' do
      mail.from.should == [donotreply]
    end

    it 'assigns @name' do
      mail.body.encoded.should match(user.name)
    end

    it 'assigns @email' do
      mail.body.encoded.should_not match(user.email)
    end

    it 'assigns myTW group url' do
      mail.body.encoded.should match(UserMailer.my_tw_url)
    end
  end

  describe 'Review creation' do
    let(:ac) {create(:associate_consultant)}
    let(:review)  {create(:review, associate_consultant: ac)}
    let(:mail) {UserMailer.review_creation(review) }

    it 'renders the subject' do
      mail.subject.should ==  "[ReviewSite] Your #{review.review_type} review has been created"
    end

    it 'renders the receiver email' do
      mail.to.should == ["#{ac.user.email}"]
    end

    it 'renders the sender email' do
      mail.from.should == [donotreply]
    end

    it 'assigns myTW group url' do
      mail.body.encoded.should match(UserMailer.my_tw_url)
    end

    it 'contains link to review' do
      mail.body.encoded.should match("You can invite peers to provide feedback and work on your self-assessment by clicking on the link:\r\n#{review_url(review)}")
    end

    it 'contains the feedback deadline and review date' do
      mail.body.encoded.should match("Your review is currently scheduled for #{review.review_date.to_s(:short_date)}")
      mail.body.encoded.should match("the deadline to submit feedback is #{review.feedback_deadline.to_s(:short_date)}")
    end
  end

  describe "Multiple reviews creation" do
    let(:mail) {UserMailer.reviews_creation(review) }

    it 'renders the subject' do
      mail.subject.should ==  "[ReviewSite] Reviews have been created for you"
    end

    it 'renders the receiver email' do
      mail.to.should == ["#{ac.user.email}"]
    end

    it 'renders the sender email' do
      mail.from.should == [donotreply]
    end

    it 'assigns myTW group url' do
      mail.body.encoded.should match(UserMailer.my_tw_url)
    end

    it 'contains link to review' do
      mail.body.encoded.should match("You can invite peers to provide feedback and work on your self-assessment by clicking on the link: #{review_url(review)}")
    end

    it 'contains the feedback deadline and review date' do
      mail.body.encoded.should match("The review is currently scheduled for #{review.review_date.to_s(:short_date)}")
      mail.body.encoded.should match("the deadline to submit feedback is #{review.feedback_deadline.to_s(:short_date)}")
    end
  end

  describe "Review update" do
    let(:invitee) { create(:user) }
    let(:user) { create(:user) }
    let(:ac) { create(:associate_consultant, user: user) }
    let(:review) { create(:review, associate_consultant: ac) }
    let(:mail) { UserMailer.review_update(invitee, review) }

    it 'includes the feedback deadline' do
      mail.body.should include("#{review.feedback_deadline.to_s(:short_date)}")
    end

    it 'includes the review ac\'s name' do
      mail.body.should include("#{user.name}")
    end

    it 'includes the reviewee\'s name' do
      mail.body.should include("#{invitee.name}")
    end
  end

  describe "Feedback submitted notification for AC" do
    let (:mail) { UserMailer.new_feedback_notification(feedback) }

    it 'renders the subject' do
      mail.subject.should == "[ReviewSite] You have new feedback from #{feedback.user}"
    end

    it 'renders the receiver email' do
      mail.to.should == [ac.user.email]
    end

    it 'renders the sender email' do
      mail.from.should == [donotreply]
    end

    it 'assigns myTW group url' do
      mail.body.encoded.should match(UserMailer.my_tw_url)
    end

    it 'addresses the receiver' do
      mail.body.encoded.should match("Hi " + ac.user.name)
    end

    it 'contains the name of the reviewer' do
      mail.body.encoded.should match(user.name)
    end

    it 'includes feedback path' do
      mail.body.encoded.should match(review_feedback_url(review, feedback))
    end
  end

  describe "Feedback submitted notification for coach" do
    let (:coach) { create(:coach) }
    let (:ac) { create(:associate_consultant, coach: coach) }
    let (:review) { create(:review, associate_consultant: ac) }
    let (:feedback) { create(:submitted_feedback, user: user, review: review) }
    let (:mail) { UserMailer.new_feedback_notification_coach(feedback) }

    it 'renders the subject' do
      mail.subject.should == "[ReviewSite] Your coachee, #{ac.to_s}, has new feedback from #{feedback.user}"
    end

    it 'renders the receiver email' do
      mail.to.should == [coach.email]
    end

    it 'renders the sender email' do
      mail.from.should == [donotreply]
    end

    it 'assigns myTW group url' do
      mail.body.encoded.should match(UserMailer.my_tw_url)
    end

    it 'addresses the receiver' do
      mail.body.encoded.should match("Hi " + coach.name)
    end

    it 'contains the name of the reviewer' do
      mail.body.encoded.should match(user.name)
    end

    it 'includes feedback path' do
      mail.body.encoded.should match(review_feedback_url(review, feedback))
    end
  end

  describe "Feedback invitation" do
    let (:mail) { UserMailer.review_invitation(review, email, message) }

    it 'renders the subject' do
      mail.subject.should == "[ReviewSite] You've been invited to give feedback for #{ac.user.name}"
    end

    it 'renders the receiver email' do
      mail.to.should == [email]
    end

    it 'renders the sender email' do
      mail.from.should == [donotreply]
    end

    it 'contains params[:message]' do
      mail.body.encoded.should match(message)
    end
  end

  describe "Feedback invitation copy sent to AC" do
    let(:emails) { [email, "second_person@thoughtworks.com"] }
    let(:mail) { UserMailer.review_invitation_AC_copy(review, message, emails) }

    it "renders the subject" do
      mail.subject.should eq "[ReviewSite] Here's a copy of your request for feedback"
    end

    it "renders the receiver email" do
      mail.to.should eq [review.associate_consultant.user.email]
    end

    it "renders the sender email" do
      mail.from.should eq [donotreply]
    end

    it "contains params[:message]" do
      mail.body.encoded.should match(message)
    end

    it "contains the emails the request was successfully sent to" do
      mail.body.encoded.should match(emails.join(", "))
    end
  end


  describe "Feedback declined" do
    let (:ac) { create(:associate_consultant) }
    let (:review) { create(:review, associate_consultant: ac) }
    let (:invitation) { review.invitations.create(email: email) }

    describe "email sent to AC" do
      let (:mail) { UserMailer.feedback_declined(invitation) }

      subject { mail }

      its (:subject) { should == "[ReviewSite] recipient@example.com has "\
        "declined your feedback request" }
      its (:to) { should == [ac.user.email] }
    end
  end

  describe "Feedback reminder" do
    let (:ac) { create(:associate_consultant) }
    let (:review) { create(:review, associate_consultant: ac) }
    let (:invitation) { review.invitations.create(email: email) }

    describe "feedback not started, deadline not passed" do
      let (:mail) { UserMailer.feedback_reminder(invitation) }
      subject { mail }

      its (:subject) { should == "[ReviewSite] Please leave feedback for #{ac.user.name}" }
      its (:to) { should == [email] }

      it 'assigns myTW group url' do
        mail.body.encoded.should match(UserMailer.my_tw_url)
      end

      it "contains reminder message" do
        CGI.unescapeHTML(mail.body.encoded).should match(
           "This is a reminder to submit your feedback for #{review}."
        )
      end

      it "contains deadline message" do
        mail.body.encoded.should match(
          "The deadline for leaving feedback is #{review.feedback_deadline.to_s(:short_date)}"
        )
      end

      it "does not say the deadline has passed" do
        mail.body.encoded.should_not match(
          "Even though the feedback deadline has passed, we would love to hear your thoughts."
        )
      end

      it "contains a new feedback link" do
        mail.body.encoded.should match(
          "To get started, please visit #{new_review_feedback_url(review)}."
        )
      end

      it "does not contain edit feedback message" do
        mail.body.encoded.should_not match (
          "You have saved feedback, but it has not yet been submitted. To continue working, please visit"
        )
      end
    end

    describe "feedback started, deadline not passed" do
      let (:reviewer) { create(:user, email: email) }
      let!(:feedback) { create(:feedback, review: review, user: reviewer) }
      let (:mail) { UserMailer.feedback_reminder(invitation) }
      subject { mail }

      its (:subject) { should == "[ReviewSite] Please leave feedback for #{ac.user.name}" }
      its (:to) { should == [email] }

      it 'assigns myTW group url' do
        mail.body.encoded.should match(UserMailer.my_tw_url)
      end

      it "contains reminder message" do
        CGI.unescapeHTML(mail.body.encoded).should match(
          "This is a reminder to submit your feedback for #{review}."
        )
      end

      it "contains deadline message" do
        mail.body.encoded.should match(
          "The deadline for leaving feedback is #{review.feedback_deadline.to_s(:short_date)}"

        )
      end

      it "does not say the deadline has passed" do
        mail.body.encoded.should_not match(
          "Even though the feedback deadline has passed, we would love to hear your thoughts."
        )
      end

      it "contains an edit feedback link" do
        mail.body.encoded.should match(
          "You have saved feedback, but it has not yet been submitted. To continue working, please visit #{edit_review_feedback_url(review, feedback)}."
        )
      end

      it "does not contain a new feedback link" do
        mail.body.encoded.should_not match(
          "To get started, please visit #{new_review_feedback_url(review)}."
        )
      end
    end

    describe "feedback not started, deadline not passed" do
      let (:mail) { UserMailer.feedback_reminder(invitation) }
      subject { mail }
      before { review.update_attribute(:feedback_deadline, Date.new(2000, 1, 1)) }

      its (:subject) { should == "[ReviewSite] Please leave feedback for #{ac.user.name}" }
      its (:to) { should == [email] }

      it 'assigns myTW group url' do
        mail.body.encoded.should match(UserMailer.my_tw_url)
      end

      it "contains reminder message" do
        CGI.unescapeHTML(mail.body.encoded).should match(
          "This is a reminder to submit your feedback for #{review}."
        )
      end

      it "says the deadline has passed" do
        mail.body.encoded.should match(
          "Even though the feedback deadline has passed, we would love to hear your thoughts."
        )
      end

      it "does not contain deadline message" do
        mail.body.encoded.should_not match(
          "The deadline for leaving feedback is 2020-01-01."
        )
      end

      it "contains a new feedback link" do
        mail.body.encoded.should match(
          "To get started, please visit #{new_review_feedback_url(review)}."
        )
      end

      it "does not contain edit feedback message" do
        mail.body.encoded.should_not match (
          "You have saved feedback, but it has not yet been submitted. To continue working, please visit"
        )
      end
    end

    describe "feedback started, deadline passed" do
      let (:reviewer) { create(:user, email: email) }
      let!(:feedback) { create(:feedback, review: review, user: reviewer) }
      let (:mail) { UserMailer.feedback_reminder(invitation) }
      subject { mail }

      before { review.update_attribute(:feedback_deadline, Date.new(2000, 1, 1)) }

      its (:subject) { should == "[ReviewSite] Please leave feedback for #{ac.user.name}" }
      its (:to) { should == [email] }

      it 'assigns myTW group url' do
        mail.body.encoded.should match(UserMailer.my_tw_url)
      end

      it "contains reminder message" do
        CGI.unescapeHTML(mail.body.encoded).should match(
          "This is a reminder to submit your feedback for #{review}."
        )
      end

      it "says the deadline has passed" do
        mail.body.encoded.should match(
          "Even though the feedback deadline has passed, we would love to hear your thoughts."
        )
      end

      it "does not contain deadline message" do
        mail.body.encoded.should_not match(
          "The deadline for leaving feedback is 2000-01-01."
        )
      end

      it "contains an edit feedback link" do
        mail.body.encoded.should match(
          "You have saved feedback, but it has not yet been submitted. To continue working, please visit #{edit_review_feedback_url(review, feedback)}."
        )
      end

      it "does not contain a new feedback link" do
        mail.body.encoded.should_not match(
          "To get started, please visit #{new_review_feedback_url(review)}."
        )
      end
    end
  end
end
