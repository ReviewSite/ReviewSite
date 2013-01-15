require 'spec_helper'

describe JuniorConsultant do
  before do
    @jc = JuniorConsultant.new(name: "Example User", email: "user@example.com", coach_id: 1)
  end

  subject { @jc }
  it{ @jc.to_s.should == "Example User" }

  it{ should respond_to(:name)}
  it{ should respond_to(:email)}
  it{ should respond_to(:notes)}
  it{ should respond_to(:reviewing_group_id)}
  it{ should respond_to(:coach_id)}

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

  it "with invalid coach email the jc shouldn't be valid" do
    @jc.coach_id = "some"
    @jc.valid?.should == false
  end

  it "with valid coach email the jc should be valid" do
    @jc.coach_id = 1
    @jc.valid?.should == true
  end

  describe "JC with reviews" do
    before(:each) do
      @jc = FactoryGirl.create(:junior_consultant)
      @review = FactoryGirl.create(:review, :junior_consultant => @jc)
    end

    it "should delete the review when the junior consultant is deleted" do
      Review.all.count.should == 1
      @jc.destroy
      Review.all.count.should == 0
    end
  end
end
