require 'spec_helper'

describe UserMailer do
  describe 'Admin registration confirmation' do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { UserMailer.admin_registration_confirmation(user) }

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

    it 'assigns @password' do
      mail.body.encoded.should match(user.password)
    end

    it 'assigns @email' do
      mail.body.encoded.should match(user.email)
    end
  end

  describe 'Self registration confirmation' do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { UserMailer.self_registration_confirmation(user) }

    it 'renders the subject' do
      mail.subject.should == 'Thank you for registering on the ReviewSite'
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

    it 'assigns @password' do
      mail.body.encoded.should match(user.password)
    end

    it 'assigns @email' do
      mail.body.encoded.should match(user.email)
    end
  end

  describe "Password reset" do
    let(:user) { FactoryGirl.create(:user, password_reset_token: 'test_token') }
    let(:mail) { UserMailer.password_reset(user) }
    subject { mail }

    its(:subject) { should == "Reset password for the ReviewSite" }
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
      mail.to.should == [jc.email]
    end

    it 'renders the sender email' do
      mail.from.should == ['do-not-reply@thoughtworks.org']
    end

    it 'addresses the receiver' do
      mail.body.encoded.should match("Dear " + jc.name)
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
    let (:params) { { email: "recipient@example.com", message: "Hello. Please leave feedback.", review_id: review.id } }
    let (:mail) { UserMailer.review_invitation(params) }

    it 'renders the subject' do
      mail.subject.should == "You've been invited to give feedback"
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

    it 'contains link to new feedback form' do
      mail.body.encoded.should match(new_review_feedback_url(review))
    end

    it 'contains the jc name' do
      mail.body.encoded.should match(jc.name)
    end

    it 'contains the review type' do
      mail.body.encoded.should match(review.review_type)
    end

    it 'contains the feedback deadline' do
      mail.body.encoded.should match(review.feedback_deadline.to_s)
    end
  end
end
