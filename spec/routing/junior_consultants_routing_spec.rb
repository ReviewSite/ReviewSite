require "spec_helper"

describe JuniorConsultantsController do
  describe "routing" do

    it "routes to #index" do
      get("/junior_consultants").should route_to("junior_consultants#index")
    end

    it "routes to #new" do
      get("/junior_consultants/new").should route_to("junior_consultants#new")
    end

    it "routes to #show" do
      get("/junior_consultants/1").should route_to("junior_consultants#show", :id => "1")
    end

    it "routes to #edit" do
      get("/junior_consultants/1/edit").should route_to("junior_consultants#edit", :id => "1")
    end

    it "routes to #create" do
      post("/junior_consultants").should route_to("junior_consultants#create")
    end

    it "routes to #update" do
      put("/junior_consultants/1").should route_to("junior_consultants#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/junior_consultants/1").should route_to("junior_consultants#destroy", :id => "1")
    end

  end
end
