require 'spec_helper'

describe SelfAssessment do
  let(:self_assessment) { SelfAssessment.new }

  before do
    self_assessment.review = FactoryGirl.create(:review)
    self_assessment.associate_consultant = FactoryGirl.create(:associate_consultant)
  end

  it "requires an ac" do
    self_assessment.valid?.should == false
    self_assessment.response = "stuff"
    self_assessment.valid?.should == true
  end

  it "requires a review" do
    self_assessment.valid?.should == false
    self_assessment.response = "stuff"
    self_assessment.valid?.should == true
  end

  it "requires response text" do
    self_assessment.valid?.should == false
  end
end
