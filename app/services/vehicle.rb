require_relative '../adapters/vehicle_adapter'
require_relative '../adapters/vehicle_adapter'
require_relative '../adapters/vehicle_brand_adapter'

module VehiclesService
  def self.vehicle_model
    @vehicle_model ||= VehicleModelAdapter.new
  end

  def self.vehicle_model=(vehicles_model)
    @vehicle_model = vehicles_model
  end

  def self.vehicle_brand
    @vehicle_brand ||= VehicleBrandAdapter.new
  end

  def self.vehicle_brand=(vehicle_brand)
    @vehicle_brand = vehicle_brand
  end

  def self.vehicle
    @vehicle ||= VehicleAdapter.new
  end

  def self.vehicle=(vehicles)
    @vehicle = vehicles
  end

  def self.create_vehicle(params)
    vehicle_brand.create_vehicle_brand(name: params[:brand]) if params[:brand].present? && !vehicle_brand.duplicated?(params[:brand])
    vehicle_brand_id = params[:brand].present? ? vehicle_brand.find_by_name(params[:brand]).id : nil
    vehicle_model.create_vehicle_model(name: params[:model], vehicle_brand_id: vehicle_brand_id ) if params[:model].present? && !vehicle_model.duplicated?(params[:model])
    params[:vehicle_model_id] = params[:model].present? ? vehicle_model.find_by_name(params[:model]).id : nil
    vehicle.create_vehicle(params.except(:brand, :model))
  end

  def self.filter(params)
    vehicles = vehicle.includes({ vehicle_model: :vehicle_brand })
    params.each do |key, value|
      vehicles = filters[key.to_sym].call(vehicles, value)
    end
    vehicles.map{ |vehicle| returned_format(vehicle) }
  end

  private

  def self.filters
    {
      brand: ->(vehicles, brand){ vehicle.filter_by_brand(vehicles, brand)},
      model: ->(vehicles, model){ vehicle.filter_by_model(vehicles, model)},
      year: ->(vehicles, year){ vehicle.filter_by_year(vehicles, year)},
      mileage: ->(vehicles, mileage){ vehicle.filter_by_mileage(vehicles, mileage)},
      price: ->(vehicles, price){ vehicle.filter_by_price(vehicles, price)}
    }
  end

  def self.returned_format(vehicle)
    {
      id: vehicle.id,
      model_name: vehicle.vehicle_model.name,
      brand_name: vehicle.vehicle_model.vehicle_brand.name,
      year: vehicle.year,
      mileage: vehicle.mileage,
      price: vehicle.price
    }
  end
end
