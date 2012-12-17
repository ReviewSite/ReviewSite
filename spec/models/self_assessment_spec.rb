require 'spec_helper'

describe SelfAssessment do
  it "requires a jc" do
    self_assessment = SelfAssessment.new
    self_assessment.review = FactoryGirl.create(:review)
    self_assessment.valid?.should == false

    self_assessment.junior_consultant = FactoryGirl.create(:junior_consultant)
    self_assessment.valid?.should == true
  end

  it "requires a review" do
    self_assessment = SelfAssessment.new
    self_assessment.junior_consultant = FactoryGirl.create(:junior_consultant)
    self_assessment.valid?.should == false

    self_assessment.review = FactoryGirl.create(:review)
    self_assessment.valid?.should == true
  end
end
