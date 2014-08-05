require 'spec_helper'

describe "reviews/new" do
  let(:ac) {FactoryGirl.create(:associate_consultant)}

  before(:each) do
    assign(:review, stub_model(Review,
                               :associate_consultant_id => ac.user.name,
      :review_type => "6-month"
    ).as_new_record)
  end

  it "renders new review form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => reviews_path, :method => "post" do
      assert_select "input#review_associate_consultant_id", :name => "review[associate_consultant_id]"
      assert_select "select#review_review_type", :name => "review[review_type]"
      assert_select "input#review_review_date", :name => "review[review_date]"
      assert_select "input#review_feedback_deadline", :name => "review[feedback_deadline]"
      assert_select "input#review_send_link_date", :name => "review[send_link_date]"
    end
  end
end
