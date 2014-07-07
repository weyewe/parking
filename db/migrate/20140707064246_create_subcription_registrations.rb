class CreateSubcriptionRegistrations < ActiveRecord::Migration
  def change
    create_table :subcription_registrations do |t|
      t.integer :subcription_product_id 
      t.integer :vehicle_registration_id 
      
      t.datetime :registration_date 
      
      # used to query whether this user has any subcription 
      t.datetime :finish_subcription_date 
      t.datetime :start_subcription_date

      t.timestamps
    end
  end
end
