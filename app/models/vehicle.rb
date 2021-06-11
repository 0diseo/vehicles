class Vehicle < ApplicationRecord
  belongs_to :vehicle_model
  validates :price, presence: true
  validates :year, presence: true
end
