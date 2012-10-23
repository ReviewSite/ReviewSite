require "spec_helper"

describe ReviewingGroupMembersController do
  describe "routing" do

    it "routes to #index" do
      get("/reviewing_group_members").should route_to("reviewing_group_members#index")
    end

    it "routes to #new" do
      get("/reviewing_group_members/new").should route_to("reviewing_group_members#new")
    end

    it "routes to #show" do
      get("/reviewing_group_members/1").should route_to("reviewing_group_members#show", :id => "1")
    end

    it "routes to #edit" do
      get("/reviewing_group_members/1/edit").should route_to("reviewing_group_members#edit", :id => "1")
    end

    it "routes to #create" do
      post("/reviewing_group_members").should route_to("reviewing_group_members#create")
    end

    it "routes to #update" do
      put("/reviewing_group_members/1").should route_to("reviewing_group_members#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/reviewing_group_members/1").should route_to("reviewing_group_members#destroy", :id => "1")
    end

  end
end
