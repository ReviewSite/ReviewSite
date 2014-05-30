require 'spec_helper'

describe JuniorConsultant do
  before do
    user = FactoryGirl.create(:user, name: "Example User")
    coach = FactoryGirl.create(:user)
    @jc = FactoryGirl.build(:junior_consultant, :coach => coach, :user => user)
  end

  subject { @jc }
  it{ @jc.to_s.should == "Example User" }

  it{ should respond_to(:notes)}
  it{ should respond_to(:reviewing_group_id)}
  it{ should respond_to(:coach_id)}

  describe "has associations" do
    it { should belong_to(:user) }
  end


  it "can have a reviewing group" do
    @jc.reviewing_group = FactoryGirl.create(:reviewing_group)
    @jc.valid?.should == true
  end

  it "shouldn't be valid with invalid coach id" do
    @jc.coach_id = "some"
    @jc.valid?.should == false
  end

  it "should be valid with valid coach id" do
    @jc.coach_id = 1
    @jc.valid?.should == true
  end

  describe "with reviews" do
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
