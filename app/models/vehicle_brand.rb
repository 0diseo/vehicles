class VehicleBrand < ApplicationRecord
  has_many :vehicle_models
  validates :name, presence: true, uniqueness: true
end
