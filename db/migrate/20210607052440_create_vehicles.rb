class CreateVehicles < ActiveRecord::Migration[6.1]
  def change
    create_table :vehicles do |t|
      t.references :vehicle_model, null: false, foreign_key: true
      t.date :year
      t.integer :mileage
      t.integer :price

      t.timestamps
    end
  end
end
