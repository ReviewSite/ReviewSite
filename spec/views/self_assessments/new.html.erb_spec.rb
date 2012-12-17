require 'spec_helper'

describe "self_assessments/new" do
  before(:each) do
    @self_assessment = FactoryGirl.create(:self_assessment)
    @review = @self_assessment.review
  end

  it "renders new self_assessment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => review_self_assessments_path(@review), :method => "post" do
      assert_select "textarea#self_assessment_response", :name => "self_assessment[response]"
    end
  end
end
