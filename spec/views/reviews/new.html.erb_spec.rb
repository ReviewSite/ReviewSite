require 'spec_helper'

describe "reviews/new" do
  let(:jc) {FactoryGirl.create(:junior_consultant)}

  before(:each) do
    assign(:review, stub_model(Review,
      :junior_consultant_id => jc.name,
      :review_type => "6-month"
    ).as_new_record)
  end

  it "renders new review form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => reviews_path, :method => "post" do
      assert_select "input#review_junior_consultant_id", :name => "review[junior_consultant_id]"
      assert_select "select#review_review_type", :name => "review[review_type]"
      assert_select "select#review_review_date_1i", :name => "review[review_date(1i)]"
      assert_select "select#review_feedback_deadline_1i", :name => "review[feedback_deadline(1i)]"
      assert_select "select#review_send_link_date_1i", :name => "review[send_link_date(1i)]"
    end
  end
end
