require 'spec_helper'

describe "reviewing_groups/edit" do
  before(:each) do
    @reviewing_group = assign(:reviewing_group, stub_model(ReviewingGroup,
      :name => "MyString"
    ))
  end

  it "renders the edit reviewing_group form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => reviewing_groups_path(@reviewing_group), :method => "post" do
      assert_select "input#reviewing_group_name", :name => "reviewing_group[name]"
    end
  end
end
