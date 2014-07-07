class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      
      
      # on create 
      t.string :license_plate_no 
      t.integer :vehicle_case 
      t.datetime :entry_datetime
      
      # on save, under create, assign code 
      t.string :code
      t.integer :customer_id 
      t.integer :vehicle_id 
      
      t.boolean :is_subcription, :default => false  
      t.integer :subcription_registration_id
  
      
      
      t.boolean :is_printed , :default => false 
      
      t.boolean :is_exit, :default => false 
      t.datetime :exit_datetime
      
      t.boolean :is_deleted, :default => false 
      t.datetime :deleted_at 

      t.timestamps
    end
  end
end
