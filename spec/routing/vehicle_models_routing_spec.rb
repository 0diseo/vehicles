require "rails_helper"

RSpec.describe VehicleModelsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/vehicle_models").to route_to("vehicle_models#index")
    end

    it "routes to #show" do
      expect(get: "/vehicle_models/1").to route_to("vehicle_models#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/vehicle_models").to route_to("vehicle_models#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/vehicle_models/1").to route_to("vehicle_models#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/vehicle_models/1").to route_to("vehicle_models#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/vehicle_models/1").to route_to("vehicle_models#destroy", id: "1")
    end
  end
end
