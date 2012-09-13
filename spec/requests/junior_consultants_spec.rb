require 'spec_helper'

describe "JuniorConsultants" do
  describe "GET /junior_consultants" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get junior_consultants_path
      response.status.should be(200)
    end
  end
end
