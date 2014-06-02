require 'spec_helper'

describe "junior_consultants/edit" do
  let(:jc) {FactoryGirl.create(:junior_consultant)}
  before(:each) do
    @junior_consultant = FactoryGirl.create(:junior_consultant)
    # @junior_consultant = assign(:junior_consultant, stub_model(JuniorConsultant))
  end

  it "renders the edit junior_consultant form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => junior_consultants_path(@junior_consultant), :method => "post" do
      assert_select "textarea#junior_consultant_notes", :name => "junior_consultant[notes]"
      assert_select "select#junior_consultant_reviewing_group_id", :name => "junior_consultant[reviewing_group_id]"
      assert_select "input#junior_consultant_coach_id", :name => "junior_consultant[coach_id]"
    end
  end
end
