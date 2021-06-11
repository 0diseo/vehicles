class VehicleBrandAdapter
  attr_reader :store

  def initialize(store = ::VehicleBrand)
    @store = store
  end

  def create_vehicle_brand(params)
    vehicle_brand = @store.new(params)
    vehicle_brand.save
    vehicle_brand
  end

  def find_by_name(name)
    @store.find_by(name: name)
  end

  def duplicated?(name)
    find_by_name(name).present?
  end
end