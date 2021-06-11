require 'rails_helper'

RSpec.describe VehicleModelAdapter, type: :model do
  let(:vehicle_model_adapter) { VehicleModelAdapter.new }
  let(:vehicle_brand) { VehicleBrand.create(name: 'wv')}

  describe 'create_vehicle_model' do
    context 'with valid parameters' do
      it 'creates a new Vehicle model' do
        expect { vehicle_model_adapter.create_vehicle_model(vehicle_brand_id: vehicle_brand.id, name: 'bocho') }.to change(vehicle_model_adapter.store, :count).by(1)
      end
    end

    context 'with invalid parameters' do
      it 'does not creates a new Vehicle model' do
        expect { vehicle_model_adapter.create_vehicle_model(name: '') }.not_to change(vehicle_model_adapter.store, :count)
      end

      it 'return name blank error' do
        vehicle = vehicle_model_adapter.create_vehicle_model(name: '', vehicle_brand_id: vehicle_brand.id)
        expect(vehicle.errors.full_messages).to eq(["Name can't be blank"])
      end

      it 'return name blank error' do
        vehicle = vehicle_model_adapter.create_vehicle_model(name: 'celica')
        expect(vehicle.errors.full_messages).to eq(['Vehicle brand must exist'])
      end
    end
  end

  describe 'find_by_name' do
    let!(:vehicle_model) { VehicleModel.create(name: 'toyota', vehicle_brand_id: vehicle_brand.id)}
    let!(:vehicle_model_2) { VehicleModel.create(name: 'nisan', vehicle_brand_id: vehicle_brand.id)}

    it 'return record' do
      expect(vehicle_model_adapter.find_by_name(vehicle_model.name)).to eq(vehicle_model)
    end

    it 'return nil if not record' do
      expect(vehicle_model_adapter.find_by_name('focus')).to eq(nil)
    end
  end

  describe 'duplicated?' do
    let!(:vehicle_model) { VehicleModel.create(name: 'tacoma', vehicle_brand_id: vehicle_brand.id)}
    it 'is duplicated' do
      expect(vehicle_model_adapter.duplicated?('tacoma')).to eq(true)
    end

    it 'is not duplicate' do
      expect(vehicle_model_adapter.duplicated?('ford')).to eq(false)
    end
  end
end

