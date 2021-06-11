require 'rails_helper'

RSpec.describe VehicleAdapter, type: :model do
  let(:vehicle_adapter) { VehicleAdapter.new }
  let(:vehicle_brand) { VehicleBrand.create(name: 'wv')}
  let(:vehicle_model) { VehicleModel.create(name: 'jetta', vehicle_brand_id: vehicle_brand.id) }
  let(:vehicle) { Vehicle.create(price: 1000, year: 2000, vehicle_model_id: vehicle_model.id) }


  describe 'create_vehicle' do
    context 'with valid parameters' do
      it 'creates a new Vehicle' do
        expect { vehicle_adapter.create_vehicle(price: 2000, year: 2000, vehicle_model_id: vehicle_model.id )}.to change(vehicle_adapter.store, :count).by(1)
      end
    end

    context 'with invalid parameters' do
      it 'does not creates a new Vehicle' do
        expect { vehicle_adapter.create_vehicle(price: 2000, year: 2000)}.not_to change(vehicle_adapter.store, :count)
      end

      it 'return vehicle_model blank error' do
        vehicle = vehicle_adapter.create_vehicle(price: 2000, year: 2000)
        expect(vehicle.errors.full_messages).to eq(['Vehicle model must exist'])
      end

      it 'return price blank error' do
        vehicle = vehicle_adapter.create_vehicle(vehicle_model_id: vehicle_model.id, year: 2000)
        expect(vehicle.errors.full_messages).to eq(["Price can't be blank"])
      end

      it 'return year blank error' do
        vehicle = vehicle_adapter.create_vehicle(price: 2000, vehicle_model_id: vehicle_model.id)
        expect(vehicle.errors.full_messages).to eq(["Year can't be blank"])
      end
    end
  end

  describe 'filter' do
    let!(:vehicle_brand_2) { VehicleBrand.create(name: 'nisan')}
    let!(:vehicle_model_2) { VehicleModel.create(name: 'tsuru', vehicle_brand_id: vehicle_brand_2.id)}
    let!(:vehicle_2) {Vehicle.create(price: 2000, year: 2010, vehicle_model_id: vehicle_model_2.id)}

    it 'filter_by_brand' do
      expect(vehicle_adapter.filter_by_brand(vehicle_adapter.store, vehicle_brand_2.name)).to eq([vehicle_2])
    end

    it 'filter_by_model' do
      expect(vehicle_adapter.filter_by_model(vehicle_adapter.store, vehicle_model.name)).to eq([vehicle])
    end

    it 'filter_by_year' do
      expect(vehicle_adapter.filter_by_year(vehicle_adapter.store, vehicle.year - 1 ).map(&:id)).to include(vehicle.id, vehicle_2.id)
    end

    it 'filter_price' do
      expect(vehicle_adapter.filter_by_price(vehicle_adapter.store, vehicle.price + 1)).to eq([vehicle])
    end

  end
end
