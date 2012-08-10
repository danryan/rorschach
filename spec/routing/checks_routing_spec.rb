require "spec_helper"

describe ChecksController do
  describe "routing" do

    it "routes to #index" do
      get("/checks").should route_to("checks#index")
    end

    it "routes to #new" do
      get("/checks/new").should route_to("checks#new")
    end

    it "routes to #show" do
      get("/checks/1").should route_to("checks#show", :id => "1")
    end

    it "routes to #edit" do
      get("/checks/1/edit").should route_to("checks#edit", :id => "1")
    end

    it "routes to #create" do
      post("/checks").should route_to("checks#create")
    end

    it "routes to #update" do
      put("/checks/1").should route_to("checks#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/checks/1").should route_to("checks#destroy", :id => "1")
    end

  end
end
