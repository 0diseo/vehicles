class VehicleModelAdapter
  attr_reader :store

  def initialize(store = ::VehicleModel)
    @store = store
  end

  def create_vehicle_model(params)
    vehicle_model = @store.new(params)
    vehicle_model.save
    vehicle_model
  end

  def find_by_name(name)
    @store.find_by(name: name)
  end

  def duplicated?(name)
    find_by_name(name).present?
  end
end

