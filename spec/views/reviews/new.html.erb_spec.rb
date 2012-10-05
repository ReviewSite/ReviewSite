require 'spec_helper'

describe "reviews/new" do
  before(:each) do
    assign(:review, stub_model(Review,
      :junior_consultant_id => 1,
      :review_type => "MyString"
    ).as_new_record)
  end

  it "renders new review form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => reviews_path, :method => "post" do
      assert_select "select#review_junior_consultant_id", :name => "review[junior_consultant_id]"
      assert_select "select#review_review_type", :name => "review[review_type]"
    end
  end
end
