require 'spec_helper'

describe "junior_consultants/new" do
  before(:each) do
    assign(:junior_consultant, stub_model(JuniorConsultant).as_new_record)
  end

  it "renders new junior_consultant form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => junior_consultants_path, :method => "post" do
          assert_select "input#junior_consultant_name", :name => "junior_consultant[name]"
    end
  end
end
