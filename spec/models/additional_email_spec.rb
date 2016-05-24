require 'spec_helper'

describe AdditionalEmail do
  let(:user) { create(:user, name: "Example User") }
  let(:email) { build(:additional_email, user_id: user.id) }

  subject { email }

  it { should respond_to(:user_id) }
  it { should respond_to(:email) }
  it { should respond_to(:confirmed_at) }
  it { should respond_to(:confirmation_sent_at) }
  it { should respond_to(:confirmation_token) }

  describe "Default values" do
    it "include an unconfirmed email" do
      email.confirmed_at.should be_falsey
    end
  end

  context "When email is blank" do
    before { email.email = "" }
    it { should_not be_valid }

    it "should have one error" do
      email.valid?
      email.errors[:email].count.should == 1
      email.errors.messages[:email].should include("can't be blank.")
    end
  end

  context "When email is invalid" do
    before { email.email = "notinvalid" }
    it { should_not be_valid }

    it "should have two errors" do
      email.valid?
      email.errors[:email].count.should == 2
      email.errors.messages[:email].should include("is invalid")
    end
  end

  context "when email is not a ThoughtWorks email" do
    before { email.email = "bademail@nottw.com" }
    it { should_not be_valid }

    it "should have one error" do
      email.valid?
      email.errors[:email].count.should == 1
      email.errors.messages[:email].should include("must be a ThoughtWorks email")
    end
  end

  context "when email does not belong to a user" do
    before { email.user_id = nil }
    it { should_not be_valid }

    it "should have one error" do
      email.valid?
      email.errors[:user_id].count.should == 1
      email.errors.messages[:user_id].should
        include("can't be blank.")
    end
  end

  context "when email is valid" do
    it "should be unique among all emails" do
      create(:user, email: "takenemail@thoughtworks.com")
      email = build(:additional_email,
        email: "takenemail@thoughtworks.com")

      email.should_not be_valid 
    end
  end
end
