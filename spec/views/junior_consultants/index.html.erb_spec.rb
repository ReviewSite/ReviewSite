require 'spec_helper'

describe "junior_consultants/index" do
  before(:each) do
    @jrs = assign(:junior_consultants, [
      stub_model(JuniorConsultant, :name => "John", :email=>"as@mm.com", :notes => "Some note"),
      stub_model(JuniorConsultant)
    ])
  end

  it "renders a list of junior_consultants" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end

  it "renders attributes in <p>" do
    render
    assert_select "tr>td", :text => @jrs[0].name, :count => 1
    assert_select "tr>td", :text => @jrs[0].email, :count => 1
    assert_select "tr>td", :text => @jrs[0].notes, :count => 1

  end


end
