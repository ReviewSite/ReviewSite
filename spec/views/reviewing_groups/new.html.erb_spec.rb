require 'spec_helper'

describe "reviewing_groups/new" do
  before(:each) do
    assign(:reviewing_group, stub_model(ReviewingGroup,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new reviewing_group form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => reviewing_groups_path, :method => "post" do
      assert_select "input#reviewing_group_name", :name => "reviewing_group[name]"
    end
  end
end
