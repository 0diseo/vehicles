require 'rails_helper'

RSpec.describe VehicleBrandAdapter, type: :model do
  let(:vehicle_brand_adapter) { VehicleBrandAdapter.new }

  describe '`create_vehicle_brand`' do
    context 'with valid parameters' do
      it 'creates a new Vehicle Brand' do
        expect { vehicle_brand_adapter.create_vehicle_brand(name: 'toyota') }.to change(vehicle_brand_adapter.store, :count).by(1)
      end
    end

    context 'with invalid parameters' do
      it 'does not creates a new Vehicle brand' do
        expect { vehicle_brand_adapter.create_vehicle_brand(name: '') }.not_to change(vehicle_brand_adapter.store, :count)
      end

      it 'return name blank error' do
        vehicle = vehicle_brand_adapter.create_vehicle_brand(name: '')
        expect(vehicle.errors.full_messages).to eq(["Name can't be blank"])
      end
    end
  end

  describe 'find_by_name' do
    let!(:vehicle_brand) { VehicleBrand.create(name: 'toyota')}
    let!(:vehicle_brand_2) { VehicleBrand.create(name: 'nisan')}

    it 'return record' do
      expect(vehicle_brand_adapter.find_by_name(vehicle_brand.name)).to eq(vehicle_brand)
    end

    it 'return nil if not record' do
      expect(vehicle_brand_adapter.find_by_name('ford')).to eq(nil)
    end
  end

  describe 'duplicated?' do
    let!(:vehicle_brand) { VehicleBrand.create(name: 'toyota')}
    it 'is duplicated' do
      expect(vehicle_brand_adapter.duplicated?('toyota')).to eq(true)
    end

    it 'is not duplicate' do
      expect(vehicle_brand_adapter.duplicated?('ford')).to eq(false)
    end
  end
end

