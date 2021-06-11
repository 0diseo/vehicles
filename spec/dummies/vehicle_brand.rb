class VehicleBrandDummy
  attr_reader :id, :name

  def initialize(attr)
    @id = attr[:id]
    @name = attr[:name]
  end
end
