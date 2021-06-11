require 'rails_helper'
require_relative '../../app/services/vehicle'
require_relative '../dummies/vehicle'
require_relative '../dummies/vehicle_model'
require_relative '../dummies/vehicle_brand'

RSpec.describe VehiclesService do

  def create_brand_stub(vehicle_brand_adapter, vehicle_brand)
    allow(vehicle_brand_adapter).to receive(:duplicated?).with( vehicle_brand.name).and_return(false)
    allow(vehicle_brand_adapter).to receive(:create_vehicle_brand).with(name: vehicle_brand.name)
    allow(vehicle_brand_adapter).to receive(:find_by_name).with(vehicle_brand.name).and_return(vehicle_brand)
  end

  def existing_brand_stub(vehicle_brand_adapter, vehicle_brand)
    allow(vehicle_brand_adapter).to receive(:duplicated?).with( vehicle_brand.name).and_return(true)
    allow(vehicle_brand_adapter).to receive(:find_by_name).with(vehicle_brand.name).and_return(vehicle_brand)
  end

  def create_model_stub(vehicle_model_adapter, vehicle_model, vehicle_brand)
    allow(vehicle_model_adapter).to receive(:duplicated?).with( vehicle_model.name).and_return(false)
    allow(vehicle_model_adapter).to receive(:create_vehicle_model).with(name: vehicle_model.name, vehicle_brand_id: vehicle_brand.id)
    allow(vehicle_model_adapter).to receive(:find_by_name).with(vehicle_model.name).and_return(vehicle_model)
  end

  def existing_model_stub(vehicle_model_adapter, vehicle_model)
    allow(vehicle_model_adapter).to receive(:duplicated?).with( vehicle_model.name).and_return(true)
    allow(vehicle_model_adapter).to receive(:find_by_name).with(vehicle_model.name).and_return(vehicle_model)
  end

  let(:vehicle_adapter) { double(VehicleAdapter) }
  let(:vehicle_brand_adapter) { double(VehicleBrandAdapter) }
  let(:vehicle_model_adapter) { double(VehicleModelAdapter) }

  before do
    VehiclesService.vehicle_model = vehicle_model_adapter
    VehiclesService.vehicle_brand = vehicle_brand_adapter
    VehiclesService.vehicle = vehicle_adapter
  end

  describe 'create_vehicle' do
    let(:vehicle) { VehicleDummy.new(id: 18) }
    let(:vehicle_brand) { VehicleBrandDummy.new(id: 12, name: 'Mazda') }
    let(:vehicle_model) { VehicleModelDummy.new(id: 8, name: '3') }

    context 'with valid parameters' do
      it 'creates a new Vehicle, vehicle brand and vehicle model' do
        create_brand_stub(vehicle_brand_adapter, vehicle_brand)
        create_model_stub(vehicle_model_adapter, vehicle_model, vehicle_brand)

        allow(vehicle_adapter).to receive(:create_vehicle).with(vehicle_model_id: vehicle_model.id, year: 2000, mileage: 1000, price: 158).and_return(vehicle)
        new_vehicle = VehiclesService.create_vehicle({ model: vehicle_model.name, brand: vehicle_brand.name, year: 2000, mileage: 1000, price: 158 })
        expect(new_vehicle).to eq(vehicle)
      end

      it 'creates a new vehicle and vehicle brand' do
        existing_brand_stub(vehicle_brand_adapter, vehicle_brand)
        create_model_stub(vehicle_model_adapter, vehicle_model, vehicle_brand)

        allow(vehicle_adapter).to receive(:create_vehicle).with(vehicle_model_id: vehicle_model.id, year: 2000, mileage: 1000, price: 158).and_return(vehicle)
        new_vehicle = VehiclesService.create_vehicle({ model: vehicle_model.name, brand: vehicle_brand.name, year: 2000, mileage: 1000, price: 158 })
        expect(new_vehicle).to eq(vehicle)
      end

      it 'creates a new vehicle and vehicle model' do
        create_brand_stub(vehicle_brand_adapter, vehicle_brand)
        existing_model_stub(vehicle_model_adapter, vehicle_model)

        allow(vehicle_adapter).to receive(:create_vehicle).with(vehicle_model_id: vehicle_model.id, year: 2000, mileage: 1000, price: 158).and_return(vehicle)
        new_vehicle = VehiclesService.create_vehicle({ model: vehicle_model.name, brand: vehicle_brand.name, year: 2000, mileage: 1000, price: 158 })
        expect(new_vehicle).to eq(vehicle)
      end
    end

    context 'with invalid parameters' do
      it 'no model parameter' do
        existing_brand_stub(vehicle_brand_adapter, vehicle_brand)
        allow(vehicle_model_adapter).to receive(:duplicated?).with( vehicle_model.name).and_return(false)

        allow(vehicle_adapter).to receive(:create_vehicle).with(vehicle_model_id: nil, year: 2000, mileage: 1000, price: 158).and_raise(ActiveRecord::RecordInvalid)
        expect {VehiclesService.create_vehicle({ brand: vehicle_brand.name, year: 2000, mileage: 1000, price: 158 })}.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'no brand parameter' do
        allow(vehicle_model_adapter).to receive(:duplicated?).with( vehicle_model.name).and_return(false)
        allow(vehicle_model_adapter).to receive(:create_vehicle_model).with(name: vehicle_model.name, vehicle_brand_id: nil).and_raise(ActiveRecord::RecordInvalid)
        expect {VehiclesService.create_vehicle({ model: vehicle_model.name, year: 2000, mileage: 1000, price: 158 })}.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe 'filter' do
    context 'with parameter' do
      let(:vehicle_brand) { VehicleBrandDummy.new(id: 6, name: 'ford') }
      let(:vehicle_model) { VehicleModelDummy.new(id: 9, name: 'mustang', vehicle_brand: vehicle_brand) }
      let(:vehicle) { VehicleDummy.new(id: 25, vehicle_model: vehicle_model, year:1960, mileage: 0, price: 2000) }

      it 'is brand' do
        allow(vehicle_adapter).to receive(:includes).with({ vehicle_model: :vehicle_brand }).and_return('vehicles')
        allow(vehicle_adapter).to receive(:filter_by_brand).with('vehicles', 'ford').and_return([vehicle])
        vehicles = VehiclesService.filter({ brand: 'ford' })
        expect(vehicles).to eq([{ brand_name: vehicle_brand.name, id: vehicle.id, mileage: vehicle.mileage, model_name: vehicle_model.name, price: vehicle.price, year:vehicle.year}])
      end

      it 'is model' do
        allow(vehicle_adapter).to receive(:includes).with({ vehicle_model: :vehicle_brand }).and_return('vehicles')
        allow(vehicle_adapter).to receive(:filter_by_model).with('vehicles', 'mustang').and_return([vehicle])
        vehicles = VehiclesService.filter({ model: 'mustang' })
        expect(vehicles).to eq([{ brand_name: vehicle_brand.name, id: vehicle.id, mileage: vehicle.mileage, model_name: vehicle_model.name, price: vehicle.price, year:vehicle.year}])
      end

      it 'is year' do
        allow(vehicle_adapter).to receive(:includes).with({ vehicle_model: :vehicle_brand }).and_return('vehicles')
        allow(vehicle_adapter).to receive(:filter_by_year).with('vehicles', '1950').and_return([vehicle])
        vehicles = VehiclesService.filter({ year: '1950' })
        expect(vehicles).to eq([{ brand_name: vehicle_brand.name, id: vehicle.id, mileage: vehicle.mileage, model_name: vehicle_model.name, price: vehicle.price, year:vehicle.year}])
      end

      it 'is mileage' do
        allow(vehicle_adapter).to receive(:includes).with({ vehicle_model: :vehicle_brand }).and_return('vehicles')
        allow(vehicle_adapter).to receive(:filter_by_mileage).with('vehicles', '0').and_return([vehicle])
        vehicles = VehiclesService.filter({ mileage: '0' })
        expect(vehicles).to eq([{ brand_name: vehicle_brand.name, id: vehicle.id, mileage: vehicle.mileage, model_name: vehicle_model.name, price: vehicle.price, year:vehicle.year}])
      end

      it 'is price' do
        allow(vehicle_adapter).to receive(:includes).with({ vehicle_model: :vehicle_brand }).and_return('vehicles')
        allow(vehicle_adapter).to receive(:filter_by_price).with('vehicles', '2001').and_return([vehicle])
        vehicles = VehiclesService.filter({ price: '2001' })
        expect(vehicles).to eq([{ brand_name: vehicle_brand.name, id: vehicle.id, mileage: vehicle.mileage, model_name: vehicle_model.name, price: vehicle.price, year:vehicle.year}])
      end
    end
  end
end
