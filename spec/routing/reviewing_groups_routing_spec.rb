require "spec_helper"

describe ReviewingGroupsController do
  describe "routing" do

    it "routes to #index" do
      get("/reviewing_groups").should route_to("reviewing_groups#index")
    end

    it "routes to #new" do
      get("/reviewing_groups/new").should route_to("reviewing_groups#new")
    end

    it "routes to #edit" do
      get("/reviewing_groups/1/edit").should route_to("reviewing_groups#edit", :id => "1")
    end

    it "routes to #create" do
      post("/reviewing_groups").should route_to("reviewing_groups#create")
    end

    it "routes to #update" do
      put("/reviewing_groups/1").should route_to("reviewing_groups#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/reviewing_groups/1").should route_to("reviewing_groups#destroy", :id => "1")
    end

  end
end
