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
      mail.from.should == ['do-not-reply@thoughtworks.com']
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
      mail.from.should == ['do-not-reply@thoughtworks.com']
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
    its(:from) { should == ['do-not-reply@thoughtworks.com'] }

    it "provides reset url" do
      mail.body.encoded.should =~ /test_token\/edit/
    end
  end
end
