require 'spec_helper'

describe User do
  let(:user) { build(:user,
                                 name: "Example User",
                                 email: "user@example.com",
                                 okta_name: "testCAS") }

  subject { user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:admin) }

  it { should be_valid }
  it { should_not be_admin }

  describe "has associations" do
    it { should have_one(:associate_consultant).dependent(:destroy) }
  end


  describe "with admin attribute set to 'true'" do
    before do
      user.save!
      user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "When name is not present" do
    before{user.name = ""}
    it { should_not be_valid}

    it "should have one error" do
      user.valid?
      user.errors[:name].count.should == 1
      user.errors.messages[:name].should include("can't be blank.")
    end
  end

  describe "when okta name is not present" do
    before { user.okta_name = "" }
    it { should_not be_valid }

    it "should have one error" do
      user.valid?
      user.errors[:okta_name].count.should == 1
      user.errors.messages[:okta_name].should include("can't be blank.")
    end
  end

  describe "When email is not present" do
    before{user.email = ""}
    it { should_not be_valid}

    it "should have one error" do
      user.valid?
      user.errors[:email].count.should == 1
      user.errors.messages[:email].should include("can't be blank.")
    end
  end

  describe "When name is too long" do
    before{user.name = "a"*51}
    it { should_not be_valid}
  end
  describe "When name is short" do
    before{user.name = "a"}
    it { should_not be_valid}
  end
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        user.email = invalid_address
        user.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        user.email = valid_address
        user.should be_valid
      end
    end
  end
  describe "when email address is already taken" do
    before do
      user_with_same_email = user.dup
      user_with_same_email.email = user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "to_s is the name" do
    it { user.to_s.should == user.name }
  end

  describe "#ac?" do
    it "returns true if a user is a ac" do
      user = create(:user)
      ac = create(:associate_consultant, :user => user)

      user.ac?.should eq(true)
    end
  end

  describe '#all_emails' do
    it 'contains primary email' do
      user.all_emails.should include(user.email)
    end
    it 'contains confirmed additional emails' do
      user = create(:user)
      additional_email = create(:additional_email, user: user, confirmed_at: Date.today)
      user.all_emails.should include(additional_email.email)
    end

    it 'does not contain unconfirmed additional emails' do
      user = create(:user)
      additional_email = create(:additional_email, user: user)
      user.all_emails.should_not include(additional_email.email)
    end
  end
end
