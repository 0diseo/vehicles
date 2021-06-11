class VehicleDummy
  attr_reader :id, :name, :vehicle_model, :year, :mileage, :price

  def initialize(attr)
    @id = attr[:id]
    @name = attr[:name]
    @vehicle_model = attr[:vehicle_model]
    @year = attr[:year]
    @mileage = attr[:mileage]
    @price = attr[:price]
  end
end
