class AddYearFromVehicle < ActiveRecord::Migration[6.1]
  def change
    add_column :vehicles, :year, :integer
  end
end
