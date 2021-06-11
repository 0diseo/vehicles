class VehicleModelDummy
  attr_reader :id, :name, :vehicle_brand

  def initialize(attr)
    @id = attr[:id]
    @name = attr[:name]
    @vehicle_brand = attr[:vehicle_brand]
  end
end
