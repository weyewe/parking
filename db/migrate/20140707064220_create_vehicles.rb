class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.string :license_plate_no
      t.integer :vehicle_case
      t.string :description 
      

      t.timestamps
    end
  end
end
