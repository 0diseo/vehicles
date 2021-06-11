require_relative '../adapters/vehicle_model_adapter'
require_relative '../adapters/vehicle_brand_adapter'

module VehicleModelService
  def self.create_vehicle_model(params)
    vehicle_brand.create_vehicle_brand(name: params[:brand]) if params[:brand].present? && !vehicle_brand.duplicated?(params[:brand])
    params[:vehicle_brand_id] = params[:brand].present? ? vehicle_brand.find_by_name(params[:brand]).id : nil
    vehicle_model.create_vehicle_model(params.except(:brand))
  end

  def self.vehicle_model
    @vehicle_model ||= VehicleModelAdapter.new()
  end

  def self.vehicle_model=(vehicles)
    @vehicle_model = vehicles
  end

  def self.vehicle_brand
    @vehicle_brand||= VehicleBrandAdapter.new()
  end

  def self.vehicle_brand=(vehicles)
    @vehicle_brand = vehicles
  end
end

