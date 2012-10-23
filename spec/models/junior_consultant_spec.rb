require 'spec_helper'

describe JuniorConsultant do
  before do
    @jc = JuniorConsultant.new(name: "Example User", email: "user@example.com")
  end

  subject { @jc }
  it{ @jc.to_s.should == "Example User" }

  it{ should respond_to(:name)}
  it{ should respond_to(:email)}
  describe "When name is not present" do
    before{@jc.name = ""}
    it { should_not be_valid}
  end
  describe "When email is not present" do
    before{@jc.email = ""}
    it { should_not be_valid}
  end
  describe "When name is too long" do
    before{@jc.name = "a"*51}
    it { should_not be_valid}
  end
  describe "When name is short" do
    before{@jc.name = "a"}
    it { should_not be_valid}
  end
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @jc.email = invalid_address
        @jc.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @jc.email = valid_address
        @jc.should be_valid
      end
    end
  end
  describe "when email address is already taken" do
    before do
      user_with_same_email = @jc.dup
      user_with_same_email.email = @jc.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end
  it "can have a reviewing group" do
    @jc.reviewing_group = FactoryGirl.create(:reviewing_group)
    @jc.valid?.should == true
  end

end
