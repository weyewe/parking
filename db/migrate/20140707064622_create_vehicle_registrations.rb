class CreateVehicleRegistrations < ActiveRecord::Migration
  def change
    create_table :vehicle_registrations do |t|

      t.integer :customer_id 
      t.integer :vehicle_id 
      
      
      t.boolean :is_deactivated, :default => false 
      t.datetime :deactivation_date 
      t.text :deactivation_description
      
      t.timestamps
    end
  end
end
