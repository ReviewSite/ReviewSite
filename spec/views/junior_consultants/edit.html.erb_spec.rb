require 'spec_helper'

describe "junior_consultants/edit" do
  before(:each) do
    @junior_consultant = assign(:junior_consultant, stub_model(JuniorConsultant))
  end

  it "renders the edit junior_consultant form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => junior_consultants_path(@junior_consultant), :method => "post" do
    end
  end
end
