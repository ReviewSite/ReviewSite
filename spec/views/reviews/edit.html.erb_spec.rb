require 'spec_helper'

describe "reviews/edit" do
  let(:jc) {FactoryGirl.create(:junior_consultant)}
  before(:each) { @review = FactoryGirl.create(:review)}

  it "renders the edit review form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => reviews_path(@review), :method => "post" do
      rendered.should match(@review.junior_consultant.user.name)
      assert_select "select#review_review_type", :name => "review[review_type]"
    end
  end
end
