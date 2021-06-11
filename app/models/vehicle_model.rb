class VehicleModel < ApplicationRecord
  has_many :vehicles
  belongs_to :vehicle_brand
  validates :name, presence: true, uniqueness: true
end
