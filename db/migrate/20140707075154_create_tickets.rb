class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :code 
      
      
      # on create 
      t.string :license_plate_no 
      t.integer :vehicle_case 
      t.datetime :entry_datetime
      
      # on save, under create, assign code 
      t.string :code
      t.boolean :is_subcription, :default => false 
      
      # optional 
      t.integer :contact_id 
      
      
      t.boolean :is_printed , :default => false 
      
      t.boolean :is_exit, :default => false 
      t.datetime :exit_datetime
      
      t.boolean :is_deleted, :default => false 
      t.datetime :deleted_at 

      t.timestamps
    end
  end
end
