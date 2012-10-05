require 'spec_helper'

describe "reviews/edit" do
  before(:each) do
    @review = assign(:review, stub_model(Review,
      :junior_consultant_id => 1,
      :review_type => "MyString"
    ))
  end

  it "renders the edit review form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => reviews_path(@review), :method => "post" do
      assert_select "select#review_junior_consultant_id", :name => "review[junior_consultant_id]"
      assert_select "select#review_review_type", :name => "review[review_type]"
    end
  end
end
