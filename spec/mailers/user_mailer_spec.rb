require 'spec_helper'

describe UserMailer do

  describe 'Registration confirmation' do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { UserMailer.registration_confirmation(user) }

    it 'renders the subject' do
      mail.subject.should == 'You were registered on the ReviewSite'
    end

    it 'renders the receiver email' do
      mail.to.should == [user.email]
    end

    it 'renders the sender email' do
      mail.from.should == ['do-not-reply@thoughtworks.org']
    end

    it 'assigns @name' do
      mail.body.encoded.should match(user.name)
    end

    it 'assigns @email' do
      mail.body.encoded.should_not match(user.email)
    end
  end

  describe 'Review creation' do
    let(:jc) {FactoryGirl.create(:junior_consultant)}
    let(:review)  {FactoryGirl.create(:new_review_type, junior_consultant: jc)}
    let(:mail) {UserMailer.review_creation(review) }

    it 'renders the subject' do
      mail.subject.should ==  "#{jc.user.name}, #{review.review_type} review is created"
    end

    it 'renders the receiver email' do
      mail.to.should == ["#{jc.user.email}"]
    end

    it 'renders the sender email' do
      mail.from.should == ['do-not-reply@thoughtworks.org']
    end

    it 'contains link to review' do
      mail.body.encoded.should match("You can invite peers to provide feedbacks and work on your self-assessment by clicking on the link:\r\n#{review_url(review)}")
    end

    it 'contains the feedback deadline and review date' do
      mail.body.encoded.should match("Please write and submit your self-assessment by #{review.review_date}")
      mail.body.encoded.should match("feedback deadline is #{review.feedback_deadline}")
    end
  end

  describe "Password reset" do
    let(:user) { FactoryGirl.create(:user, password_reset_token: 'test_token') }
    let(:mail) { UserMailer.password_reset(user) }
    subject { mail }

    its(:subject) { should == "Recover account for the ReviewSite" }
    its(:to) { should == [user.email] }
    its(:from) { should == ['do-not-reply@thoughtworks.org'] }

    it "provides reset url" do
      mail.body.encoded.should =~ /test_token\/edit/
    end
  end

  describe "Feedback submitted notification" do
    let (:user) { FactoryGirl.create(:user) }
    let (:jc) { FactoryGirl.create(:junior_consultant) }
    let (:review) { FactoryGirl.create(:review, junior_consultant: jc) }
    let (:feedback) { FactoryGirl.create(:submitted_feedback, user: user, review: review) }
    let (:mail) { UserMailer.new_feedback_notification(feedback) }

    it 'renders the subject' do
      mail.subject.should == 'You have new feedback'
    end

    it 'renders the receiver email' do
      mail.to.should == [jc.user.email]
    end

    it 'renders the sender email' do
      mail.from.should == ['do-not-reply@thoughtworks.org']
    end

    it 'addresses the receiver' do
      mail.body.encoded.should match("Dear " + jc.user.name)
    end

    it 'contains the name of the reviewer' do
      mail.body.encoded.should match(user.name)
    end

    it 'includes feedback path' do
      mail.body.encoded.should match(review_feedback_url(review, feedback))
    end
  end

  describe "Feedback invitation" do
    let (:jc) { FactoryGirl.create(:junior_consultant) }
    let (:review) { FactoryGirl.create(:review, junior_consultant: jc, feedback_deadline: Date.today) }
    let (:email) { "recipient@example.com" }
    let (:message) { "Hello. Please leave feedback." }
    let (:mail) { UserMailer.review_invitation(review, email, message) }

    it 'renders the subject' do
      mail.subject.should == "You've been invited to give feedback for #{jc.user.name}."
    end

    it 'renders the receiver email' do
      mail.to.should == ["recipient@example.com"]
    end

    it 'renders the sender email' do
      mail.from.should == ['do-not-reply@thoughtworks.org']
    end

    it 'contains params[:message]' do
      mail.body.encoded.should match("Hello. Please leave feedback.")
    end
  end


  describe "Feedback reminder" do
    let (:jc) { FactoryGirl.create(:junior_consultant) }
    let (:review) { FactoryGirl.create(:review, junior_consultant: jc, feedback_deadline: Date.new(2020, 1, 1)) }
    let (:email) { "recipient@example.com" }
    let (:invitation) { review.invitations.create(email: email) }

    describe "feedback not started, deadline not passed" do
      let (:mail) { UserMailer.feedback_reminder(invitation) }
      subject { mail }

      its (:subject) { should == "Please leave feedback for #{jc.user.name}." }
      its (:to) { should == ["recipient@example.com"] }

      it "contains reminder message" do
        mail.body.encoded.should match(
          "This is a reminder to submit some feedback for the #{review.review_type} review of #{jc.user.name}."
        )
      end

      it "contains deadline message" do
        mail.body.encoded.should match(
          "The deadline for leaving feedback is 2020-01-01."
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
      let (:reviewer) { FactoryGirl.create(:user, email: "recipient@example.com") }
      let!(:feedback) { FactoryGirl.create(:feedback, review: review, user: reviewer) }
      let (:mail) { UserMailer.feedback_reminder(invitation) }
      subject { mail }

      its (:subject) { should == "Please leave feedback for #{jc.user.name}." }
      its (:to) { should == ["recipient@example.com"] }

      it "contains reminder message" do
        mail.body.encoded.should match(
          "This is a reminder to submit some feedback for the #{review.review_type} review of #{jc.user.name}."
        )
      end

      it "contains deadline message" do
        mail.body.encoded.should match(
          "The deadline for leaving feedback is 2020-01-01."
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

      its (:subject) { should == "Please leave feedback for #{jc.user.name}." }
      its (:to) { should == ["recipient@example.com"] }

      it "contains reminder message" do
        mail.body.encoded.should match(
          "This is a reminder to submit some feedback for the #{review.review_type} review of #{jc.user.name}."
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
      let (:reviewer) { FactoryGirl.create(:user, email: "recipient@example.com") }
      let!(:feedback) { FactoryGirl.create(:feedback, review: review, user: reviewer) }
      let (:mail) { UserMailer.feedback_reminder(invitation) }
      subject { mail }

      before { review.update_attribute(:feedback_deadline, Date.new(2000, 1, 1)) }

      its (:subject) { should == "Please leave feedback for #{jc.user.name}." }
      its (:to) { should == ["recipient@example.com"] }

      it "contains reminder message" do
        mail.body.encoded.should match(
          "This is a reminder to submit some feedback for the #{review.review_type} review of #{jc.user.name}."
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
