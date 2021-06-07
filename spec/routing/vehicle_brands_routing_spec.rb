require "rails_helper"

RSpec.describe VehicleBrandsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/vehicle_brands").to route_to("vehicle_brands#index")
    end

    it "routes to #show" do
      expect(get: "/vehicle_brands/1").to route_to("vehicle_brands#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/vehicle_brands").to route_to("vehicle_brands#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/vehicle_brands/1").to route_to("vehicle_brands#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/vehicle_brands/1").to route_to("vehicle_brands#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/vehicle_brands/1").to route_to("vehicle_brands#destroy", id: "1")
    end
  end
end
