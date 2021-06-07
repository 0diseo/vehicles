class CreateVehicleModels < ActiveRecord::Migration[6.1]
  def change
    create_table :vehicle_models do |t|
      t.references :vehicle_brand, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
