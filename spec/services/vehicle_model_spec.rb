require 'rails_helper'
require_relative '../../app/services/vehicle_model'
require_relative '../dummies/vehicle_model'
require_relative '../dummies/vehicle_brand'

RSpec.describe VehicleModelService do

  let(:vehicle_brand_adapter) { double(VehicleBrandAdapter) }
  let(:vehicle_model_adapter) { double(VehicleModelAdapter) }

  def create_brand_stub(vehicle_brand_adapter, vehicle_brand)
    allow(vehicle_brand_adapter).to receive(:duplicated?).with( vehicle_brand.name).and_return(false)
    allow(vehicle_brand_adapter).to receive(:create_vehicle_brand).with(name: vehicle_brand.name)
    allow(vehicle_brand_adapter).to receive(:find_by_name).with(vehicle_brand.name).and_return(vehicle_brand)
  end

  def existing_brand_stub(vehicle_brand_adapter, vehicle_brand)
    allow(vehicle_brand_adapter).to receive(:duplicated?).with( vehicle_brand.name).and_return(true)
    allow(vehicle_brand_adapter).to receive(:find_by_name).with(vehicle_brand.name).and_return(vehicle_brand)
  end

  before do
    VehicleModelService.vehicle_model = vehicle_model_adapter
    VehicleModelService.vehicle_brand = vehicle_brand_adapter
  end

  describe 'create_vehicle_model' do
    let(:vehicle_brand) { VehicleBrandDummy.new(id: 12, name: 'Mazda') }
    let(:vehicle_model) { VehicleModelDummy.new(id: 8, name: '3') }

    context 'with valid parameters' do
      it 'creates a vehicle brand and vehicle model' do
        create_brand_stub(vehicle_brand_adapter, vehicle_brand)

        allow(vehicle_model_adapter).to receive(:create_vehicle_model).with(name: vehicle_model.name, vehicle_brand_id: vehicle_brand.id).and_return(vehicle_model)
        new_vehicle_model = VehicleModelService.create_vehicle_model({ name: vehicle_model.name, brand: vehicle_brand.name })
        expect(new_vehicle_model).to eq(vehicle_model)
      end

      it 'creates a new vehicle  model' do
        existing_brand_stub(vehicle_brand_adapter, vehicle_brand)

        allow(vehicle_model_adapter).to receive(:create_vehicle_model).with(name: vehicle_model.name, vehicle_brand_id: vehicle_brand.id).and_return(vehicle_model)
        new_vehicle_model = VehicleModelService.create_vehicle_model({ name: vehicle_model.name, brand: vehicle_brand.name })
        expect(new_vehicle_model).to eq(vehicle_model)
      end
    end

    context 'with invalid parameters' do
      it 'no model parameter' do
        existing_brand_stub(vehicle_brand_adapter, vehicle_brand)

        allow(vehicle_model_adapter).to receive(:create_vehicle_model).with(name: '', vehicle_brand_id: vehicle_brand.id).and_raise(ActiveRecord::RecordInvalid)
        expect { VehicleModelService.create_vehicle_model({ name: '', brand: vehicle_brand.name })}.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'no brand parameter' do
        allow(vehicle_model_adapter).to receive(:create_vehicle_model).with(name: vehicle_brand.name, vehicle_brand_id: nil).and_raise(ActiveRecord::RecordInvalid)
        expect { VehicleModelService.create_vehicle_model({ name: vehicle_brand.name, brand: '' })}.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end