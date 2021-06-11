require_relative 'vehicle_model_adapter'
require_relative 'vehicle_brand_adapter'

class VehicleAdapter
  attr_reader :store

  def initialize (store = ::Vehicle)
    @store = store
  end

  def create_vehicle(params)
    vehicle = @store.new(params)
    vehicle.save
    vehicle
  end

  def includes(params)
    @store.includes(params)
  end

  def filter_by_brand(vehicles, brand)
    vehicles.where( vehicle_model: VehicleModelAdapter.new.store.where(vehicle_brand: VehicleBrandAdapter.new.store.where(name: brand)))
  end

  def filter_by_model(vehicles, model)
    vehicles.where( vehicle_model: VehicleModelAdapter.new.store.where(name: model))
  end

  def filter_by_year(vehicles, year)
    vehicles.where( 'year > ?', year)
  end

  def filter_by_mileage(vehicles, mileage)
    vehicles.where('mileage < ?', mileage)
  end

  def filter_by_price(vehicles, price)
    vehicles.where('price < ?', price )
  end
end

