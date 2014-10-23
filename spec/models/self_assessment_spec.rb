require 'spec_helper'

describe SelfAssessment do
  it "requires an ac" do
    self_assessment = SelfAssessment.new
    self_assessment.review = FactoryGirl.create(:review)
    self_assessment.valid?.should == false

    self_assessment.associate_consultant = FactoryGirl.create(:associate_consultant)
    self_assessment.response = "stuff"
    self_assessment.valid?.should == true
  end

  it "requires a review" do
    self_assessment = SelfAssessment.new
    self_assessment.associate_consultant = FactoryGirl.create(:associate_consultant)
    self_assessment.valid?.should == false

    self_assessment.review = FactoryGirl.create(:review)
    self_assessment.response = "stuff"
    self_assessment.valid?.should == true
  end

  it "requires response text" do
    self_assessment = SelfAssessment.new
    self_assessment.associate_consultant = FactoryGirl.create(:associate_consultant)
    self_assessment.review = FactoryGirl.create(:review)
    self_assessment.valid?.should == false
  end
end
